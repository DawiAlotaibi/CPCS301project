#This method will check two strings for diffrences and return the diffrence as well as the string 
def string_difference_percent(str1, str2)
    longer = [str1[0].size, str2.size].max #Take the longer String 
    #Next statment will check char by char bettween the first string and the second string case insensitive
    #if they are matched they will be added to a new string varible
    same = str1[0].each_char.zip(str2.each_char).select { |str1,str2| str1.casecmp(str2) == 0 }.size
    #next we will return the diffrnce bettween the length of the longest string the the length of the newly assigned string
    #and dived them by the length of the first string and then we return them back to the caller
    return (longer - same) / str1[0].size.to_f ,str1
  end



#This statment will check if the input file is present and/or it is misspelled
#So We will print an erorr massage and quit the program
if !File.exists? "input.txt"
    puts "Input file is not present or it's name is not \"input.txt\"
Please check and try again."
    exit
end

spliter =  /,\s*/ # This is the spliter on which we will split input
employees = [] #This Array is for storing all the names,salarys of employees
file = File.open("input.txt") #open the input file and create a variable for it 
file.each_line {|line| employees << line.split(spliter) }#read the names and salaries from the file and add it to the array
for i in employees do
    i[0] = i[0].split.join(" ")#Remove any unwanted sapacess in the names and join the first and last name by a (" ")
    i[1] = i[1].gsub("\n","")
end

loop do # start of the loop for the proram
    # displaying the menu
    puts "-----------WELCOME TO THE EMPLOYEE DATABASE-----------"
    puts "------------------------------------------------------"
    puts "Enter 1 to find a salry by an employee name"
    puts "Enter 2 to print the sum, minimum and maximum of the salaries"
    puts "Enter 3 to Add a new employee"
    puts "Enter 4 to delete an employee from the database"
    puts "Enter 5 to Exit from the program and save the list"
    puts "------------------------------------------------------"
    print "ENTRY:"
    case command = gets.chomp.to_i # read the user's command
        when 1 #this case will search the array by a name and find the salary of that person
            print "Enter the name which you want to find it's salary: "
            name = gets.chomp() #get user input
            name=name.split.join(" ") #Remove any unwanted spaces
            closestName = [] # this array will hold all diffrences bettwen the enterd name and all names in the system
            for i in employees do
                closestName << string_difference_percent(i,name) #Add the result into closestname array
            end
            #Display the accurcy presentage and the closent name found
            puts "The closest employee record with an accurcy of : %%%.2f IS: \n" % [100-(closestName.min()[0]*100)]
            puts "employee : #{closestName.min()[1][0]} with the salary of: #{closestName.min()[1][1]}"
            puts "\n"
    when 2
        #All used varibles this is like max = 0 , maxName = "n/a" etc.
        max,maxName,sum,min,minName=0,"n/a",0,2**30-1,"n/a"
        for i in employees do
            if i[1].to_i > max #Check if current max is smaller than current max
                max = i[1].to_i #if so, then change max and max name with current
                maxName = i[0]
            end
            if i[1].to_i < min #Check if current min is bigger than current min
                min = i[1].to_i#if so, then change min and min name with current
                minName = i[0]
            end
            sum += i[1].to_i #add Sum with it self
        end
        #print max,min and sum
        puts "Max Salary is #{max} For Employee named: #{maxName}"
        puts "Min Salary is #{min} For Employee named:  #{minName}"
        puts "Sum of the Salary is #{sum}"
        puts "\n"
    when 3
        loop do #loop to allow the user to input until he met the right pattern
            puts "Add name and salary seperated by a comma \",\" Or enter \"QUIT\" To quit the process:"
            addedName = gets.chomp.split(spliter) #take name and salary as array
            addedName[0] =addedName[0].split.join(" ") #split unwanted spaces
            if addedName[0].match("QUIT")#to go back to the menu if the user input QUIT
                break
            end
            #Check if the array size is not 2 or the name or salary doesent follow the foramt
            #name format : must have at least 3 any upper or lower litter or spaces
            #salary must only contain digits
            if addedName.size !=2 or !addedName[0].match(/([a-zA-Z\s]){3,}/) or !addedName[1].match(/(\d)+/)
                puts "Entered input doesn't follow the CSV Format"
                next
            end  
            employees << addedName #add name to the array 
            puts "employee named: #{addedName[0]}, successfully added to the system" #print success massage
            puts "\n"
            break # end loop and go back to the main menu
    end
    when 4
        puts "Enter the name of the employee to be deleted (MUST BE EXACT):"
        deletedName = gets.chomp #get name to be deleted
        deletedName = deletedName.split.join(" ")#remove unwanted space
        flag = false #Flag to check if name was found or not
        for i in employees do
            if i[0].match(deletedName) #if name in the array = name to be deleted
                employees.delete(i) # delete name 
                flag =true #change flag to true 
            end
        end
        if flag # print either deleted or not depending on the flag
            puts "employee named: #{deletedName}, successfully deleted from the system"
        else
            puts "employee named: #{deletedName}, was not found"
        end
        puts "\n"
    when 5
        #open a new file put this time to write in
        output = File.open( "output.txt","w" )
        for i in employees do 
            output << "#{i.join(", ")}\n"#write in the file by the format of CSV from the array
        end
        output.close
        break
    else #any other user input 
        puts "invalid input try again"
        puts "\n"
    end
end
#print good bye massage and stop the program
puts "Thank You For using our system
    Good bye"