class SQLObject

  def self.find_by_id(id)
    attributes = QuestionsDatabase.instance.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        id = ?
    SQL

    self.new(attributes)
  end

  def self.all
    attributes = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
    SQL
  end
end

  # def save
  #   variables_raw = self.instance_variables.map {|var| var.gsub("@", "") }
  #   varibles_no_id = variables_raw.dup.drop
  #
  #   v_joined = variables_raw.join(", ")
  #   v_no_id_joined = variables_no_id.join(", ")
  #
  #   question_marks = ("? " * variables_raw.count).split.join(", ")
  #   question_marks_no_id = ("? " * variables_no_id.count).split.join(", ")
  #
  #   if self.id.nil?
  #     QuestionsDatabase.instance.execute(<<-SQL, v_no_id_joined)
  #       INSERT INTO
  #         "#{self::TABLE_NAME} (#{v_no_id_joined})"
  #       VALUES
  #         ( #{question_marks_no_id}) )
  #     SQL
  #
  #     @id = QuestionsDatabase.instance.last_insert_row_id
  #   else
  #     QuestionsDatabase.instance.execute(<<-SQL, v_joined)
  #       UPDATE
  #         "#{self::TABLE_NAME} (#{v_no_id_joined})"
  #       -- SET
  #       --   -- title = ?, body = ?, author_id = ?
  #       -- WHERE
  #       --   ( #{question_marks}) )
  #     SQL
  #   end
  # end
