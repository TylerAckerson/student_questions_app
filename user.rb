require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'

class User < SQLObject
  TABLE_NAME = 'users'

  def self.find_by_name(fname, lname)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, fname, lname).first
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    User.new(attributes)
  end

attr_accessor :fname, :lname
attr_reader :id

  def initialize(attributes = {})
    @id = attributes[ "id" ]
    @fname = attributes[ "fname" ]
    @lname = attributes[ "lname"]
  end

  def save
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (? , ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          users.id = ?
      SQL
    end
end


  def authored_questions
    Question::find_by_author_id(@id)
  end

  def authored_replies
    Reply::find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow::followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike::liked_questions_for_user_id(@id)
  end

  def average_karma
    # question_likes_count = QuestionsDatabase.instance.execute(<<-SQL)
    #   SELECT
    #     questions.id,
    #     COUNT(DISTINCT(question_likes.user_id))
    #   FROM
    #     questions
    #   LEFT OUTER JOIN
    #     question_likes ON questions.id = question_likes.question_id
    #   GROUP BY
    #     questions.id
    # SQL

    user_questions_count = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.author_id user,
        questions.id question,
        COUNT(questions.id)
      FROM
        users
      LEFT OUTER JOIN
        questions ON users.id = questions.author_id
      GROUP BY
        questions.author_id
    SQL

  end
end
