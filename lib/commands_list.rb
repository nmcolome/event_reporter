class CommandList

  def list
    ">>load <filename>\n>>find <attribute> <criteria>\n>>queue count\n>>queue clear\n>>queue print\n>>queue print by <attribute>\n>>queue save to <filename.csv>\n>>queue export html <filename.csv>\n>>help\n>>help <command>"
  end

  def flow(parameters)
    case parameters
    when "load <filename>", "load"
      load_file
    when "find <attribute> <criteria>"
      find
    when "queue count"
      queue_count
    when "queue clear"
      queue_clear
    when "queue print"
      queue_print
    when "queue print by <attribute>"
      queue_print_by
    when "queue save to <filename.csv>"
      queue_save
    when "queue export html <filename.csv>"
      queue_export
    when "help"
      help
    when "help <command>"
      help_command
    end
  end

  def load_file
    "load <filename>
    Erase any loaded data and parse the specified file. If no filename is given, default to full_event_attendees.csv."
  end

  def find
    "find <attribute> <criteria>
    Populate the queue with all records matching the criteria for the given attribute. Example usages:
    find zipcode 20011
    find last_name Johnson
    find state VA"
  end

  def queue_count
    "queue count
    Output how many records are in the current queue"
  end

  def queue_clear
    "queue clear
    Empty the queue"
  end

  def queue_print
    "queue print
    Print out a tab-delimited data table with a header row following this format:
    LAST NAME  FIRST NAME  EMAIL  ZIPCODE  CITY  STATE  ADDRESS  PHONE"
  end

  def queue_print_by
    "queue print by <attribute>
    Print the data table sorted by the specified attribute like zipcode."
  end

  def queue_save
    "queue save to <filename.csv>
    Export the current queue to the specified filename as a CSV. The file should include data and headers for last name, first name, email, zipcode, city, state, address, and phone number."
  end

  def queue_export
    "queue export html <filename.csv>
    Export the current queue to the specified filename as a valid HTML file. The file should use tables and include the data for all of the expected information."
  end

  def help
    "help
    Output a listing of the available individual commands"
  end

  def help_command
    "help <command>
    Output a description of how to use the specific command. For example:
    help queue clear
    help find"
  end
end