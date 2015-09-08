require_relative 'questions_database'
require_relative 'user'
require_relative 'question'

class Reply
  def self.find_by_id(id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    return nil unless attributes
    Reply.new(attributes)
  end

  def self.find_by_user_id(author_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL

    return nil unless attributes
    attributes.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    return nil unless attributes
    attributes.map { |result| Reply.new(result) }
  end

  attr_accessor :question_id, :parent_reply_id, :author_id, :body

  def initialize(attributes)
    @id = attributes[ "id" ]
    @question_id = attributes[ "question_id" ]
    @parent_reply_id = attributes[ "parent_reply_id" ]
    @author_id = attributes[ "author_id" ]
    @body = attributes[ "body"]
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

  def question
    attributes = QuestionsDatabase.instance.execute(<<-SQL).first
      SELECT
        *
      FROM
        questions
      WHERE
        id = #{@question_id}
    SQL

    Question.new(attributes)
  end

  def parent_reply
    attributes = QuestionsDatabase.instance.execute(<<-SQL).first
      SELECT
        *
      FROM
        replies
      WHERE
        id = #{@parent_reply_id}
    SQL

    Reply.new(attributes)
  end

  def child_replies
    attributes = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = #{@id}
    SQL

    return nil unless attributes
    attributes.map { |result| Reply.new(result) }
  end
end
