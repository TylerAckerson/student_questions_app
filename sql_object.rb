class SQLObject
  # @@table = nil

  def self.find_by_id(id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    superclass.new(attributes)
  end
end
