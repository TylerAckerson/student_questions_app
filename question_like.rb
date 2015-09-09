require_relative 'questions_database'
require_relative 'question'

class QuestionLike < SQLObject
  TABLE_NAME = 'question_likes'

  def self.likers_for_question_id(question_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL

    attributes.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, question_id).first
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = ?
      ORDER BY
        COUNT(user_id)
    SQL

    return attributes.values.first #values of hash is defaulted to an array
  end

  def self.liked_questions_for_user_id(user_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    attributes.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.user_id) DESC
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
