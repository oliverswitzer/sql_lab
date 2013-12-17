require 'mysql2'
require 'debugger'

class Dog
  
  @@db = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "dogs")

  attr_accessor :name, :color, :id

  def initialize name, color, id=nil
    @name = name
    @color = color
    @id = id
  end

  def self.db
    @@db
  end

  def db
    @@db
  end

  def self.find_by(attribute, value)
    matched_rows = []

    if value.class == Fixnum
      query = @@db.query("
        SELECT *
        FROM dogs
        WHERE #{attribute} = #{value}
        ")
    else
       query = @@db.query("
        SELECT *
        FROM dogs
        WHERE #{attribute} = '#{value}'
        ")
    end

    if query.first.nil?
      return "whimper" 
    else
      query.each do |row|
        matched_rows << Dog.new(row["name"], row["color"], row["id"])
      end
    end

    return matched_rows
  end
  
  def insert 
    db.query("
      INSERT INTO dogs (name, color)
      VALUES ('#{name}', '#{color}')")
    self.id = db.last_id
    "#{self.name} inserted into dogs database with ID #{self.id}"
  end

  def update
    db.query("
      UPDATE dogs
      SET name = '#{name}', color = '#{color}'
      WHERE id = #{id}
      ")
    "#{self.name} update in dogs with name = #{name} and color = #{color}"
  end

  def has_id?
    if self.id.nil?
      false
    else
      true
    end
  end

  def delete!
    if self.has_id?
      db.query("
        DELETE FROM dogs
        WHERE id = #{self.id} 
        ")
      "#{self.name} with ID #{self.id} deleted from database"
    else
      "This dog is not in the database! (Object ID: #{self.object_id})"
    end
  end

  def save!
    if self.has_id?
      self.update
    else
      self.insert 
    end
  end

  def inspect
    "I'm a dog named #{self.name} with a color #{self.color}"
  end

  def ==(other_dog)
    if self.name == other_dog.name
      true
    else
      false
    end
  end

  def self.new_from_db(id)
    return_row = db.query("
      SELECT * FROM dogs
      WHERE id = #{id}").first
    Dog.new(return_row["name"], return_row["color"], return_row["id"])
  end


end


debugger
puts 'hi'

  # color, name, id
  # db
  # find_by_att
  # find
  # insert
  # update
  # delete/destroy

  # refactorings?
  # new_from_db?
  # saved?
  # save! (a smart method that knows the right thing to do)
  # unsaved?
  # mark_saved!
  # ==
  # inspect
  # reload
  # attributes

