class EventManager
  require 'pry'
  require 'csv'
  require './lib/commands_list.rb'

  def initialize
    @content = nil
    @queue_count = 0
    @results = nil
    @table = [["LAST NAME","FIRST NAME","EMAIL","ZIPCODE","CITY","STATE","ADDRESS","PHONE"]]
  end

  def load_content(file)
    CSV.open "./#{file}", headers: true, header_converters: :symbol
  end

  def queue_flow(action)
    if action == "count"
      p @queue_count
    elsif action == "clear"
      @queue_count = 0
    elsif action == "print"
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
      @table.each { |table_row| puts table_row.join("\t\t") }
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
      @content = load_content(command[1])
    elsif command[0].downcase == "find"
      @results = @content.find_all do |row|
        first_name = row[:first_name]
        first_name.capitalize.chomp == command[2].capitalize
      end
      @queue_count = @results.count
    elsif command[0].downcase == "queue"
      queue_flow(command[1].downcase)
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

