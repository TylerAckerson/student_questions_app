require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class QuestionFollow
  def self.find_by_id(id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    QuestionFollow.new(attributes)
  end

  def self.followers_for_question_id(question_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL

    attributes.map { |result| QuestionFollow.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_follows.user_id = ?
    SQL

    attributes.map { |result| QuestionFollow.new(result) }
  end

  def self.most_followed_questions(n)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      JOIN
        users ON question_follows.user_id = users.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(users.id) DESC
      LIMIT
        ?
    SQL

    attributes.map { |result| Question.new(result) }
  end
  
  attr_accessor :user_id, :question_id

  def initialize(attributes)
    @id = attributes[ "id" ]
    @user_id = attributes[ "user_id" ]
    @question_id = attributes[ "question_id"]
  end


end
