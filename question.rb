require_relative 'questions_database'
require_relative 'user'
require_relative 'question_follow'
require_relative 'question'
require_relative 'question_like'

class Question
  def self.find_by_id(id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(attributes)
  end

  def self.find_by_author_id(author_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    attributes.map { |result| Question.new(result) }
  end

  def self.most_followed(n)
    QuestionFollow::most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike::most_liked_questions(n)
  end

  attr_accessor :title, :body, :author_id

  def initialize(attributes)
    @id = attributes[ "id" ]
    @title = attributes[ "title" ]
    @body = attributes[ "body"]
    @author_id = attributes[ "author_id" ]
  end

  def author
    attributes = QuestionsDatabase.instance.execute(<<-SQL).first
      SELECT
        *
      FROM
        users
      WHERE
        id = #{@author_id}
    SQL

    User.new(attributes)
  end

  def replies
    Reply::find_by_question_id(@id)
  end

  def followers
    QuestionFollow::followers_for_question_id(@id)
  end

  def likers
    QuestionLike::likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike::num_likes_for_question_id(@id)
  end
end
