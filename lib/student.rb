require 'pry'
 class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    #binding.pry
    new_student = Student.new
    Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    #all_students = DB[:conn].execute("select * from students")
    # remember each row should be a new instance of the Student class
    #self.new_from_db(all_students)
    sql = <<-SQL
       select * from students
    SQL
    #binding.pry
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)

      end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    #binding.pry
    sql = <<-SQL
      select *
      from students
      where name =?
      limit 1
    SQL
    row = DB[:conn].execute(sql, name).flatten
    # return a new instance of the Student class
    self.new_from_db(row)
  end

def self.count_all_students_in_grade_9
  sql = <<-SQL
  select * from students
  where grade = 9
  SQL
  DB[:conn].execute(sql)
end

def self.students_below_12th_grade
  sql = <<-SQL
  select * from students
  where grade <= 11
  SQL
  DB[:conn].execute(sql)
end

def self.first_x_students_in_grade_10(num)
  sql = <<-SQL
  select * from students
  where grade = 10
  SQL
  #binding.pry
  DB[:conn].execute(sql)[0..num-1]

end

def self.first_student_in_grade_10
  sql = <<-SQL
  select * from students
  where grade = 10
  SQL
  #binding.pry
  student = DB[:conn].execute(sql)[0]
  self.new_from_db(student)
end

def self.all_students_in_grade_x(grade)
  sql = <<-SQL
  select * from students
  where grade = ?
  SQL
  DB[:conn].execute(sql, grade)
end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end


  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
