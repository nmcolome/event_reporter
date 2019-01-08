class EventManager
  require 'pry'
  require 'csv'
  require './lib/commands_list.rb'

  def initialize
    @content = nil
    @queue_count = 0
    @results = nil
    @header = ["LAST NAME","FIRST NAME","EMAIL","ZIPCODE","CITY","STATE","ADDRESS","PHONE"]
  end

  def load_content
    # CSV.open "./#{file}", headers: true, header_converters: :symbol
    CSV.open "./full_event_attendees.csv", headers: true, header_converters: :symbol
  end

  def find(command)
    @results = @content.find_all do |row|
      searched_value = row[command[1].to_sym]
      searched_value.to_s.downcase.chomp == command[2..-1].join(" ").downcase
    end
    @queue_count = @results.count
  end

  def attributes
    {
      "last_name": 0,
      "first_name": 1,
      "email": 2,
      "zipcode": 3,
      "city": 4,
      "state": 5,
      "address": 6,
      "phone": 7
    }
  end

  def queue_flow(action)
    if action[1] == "count"
      p @queue_count
    elsif action[1] == "clear"
      @queue_count = 0
    elsif action[1] == "print"
      build_table
      if action[2] == "by"
        sorted = @table.sort_by { |table_row| table_row[attributes[action[-1].to_sym]] }
        sorted.unshift(@header)
        sorted.each { |table_row| puts table_row.join("\t\t") }
      else
        @table.unshift(@header)
        @table.each { |table_row| puts table_row.join("\t\t") }
      end
    elsif action[1] == "save"
      CSV.open("./#{action[-1]}", "wb") do |csv|
        @table.each do |row|
          csv << row
        end
      end
    end
  end

  def build_table
    @table = []
    @results.each do |row|
      @table << [
                  row[:last_name],
                  row[:first_name],
                  row[:email_address],
                  row[:zipcode],
                  row[:city],
                  row[:street],
                  row[:homephone]
                ]
    end
  end

  def help_flow(command)
    text = CommandList.new
    if command.empty?
      puts text.list
    else
      puts text.flow(command.join(" "))
    end
  end

  def flow_control(command)
    if command[0].downcase == "load"
      @content = load_content
    elsif command[0].downcase == "find"
      find(command)
    elsif command[0].downcase == "queue"
      queue_flow(command)
    elsif command[0].downcase == "help"
      command.shift
      help_flow(command)
    end
  end
end

event_manager = EventManager.new
command = ""
while command != 'quit' do
  puts "Enter a command:"
  answer = gets.chomp
  command = answer.split(" ")
  event_manager.flow_control(command)
end

