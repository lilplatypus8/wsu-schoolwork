# Josiah Schmitz

# Create output file for writing student records (if it doesn't exist)
output_file = open("studentRecordsOut.txt", "w") 


class Student:
    
    def __init__(self, uid, first_name, last_name, level, classes):
        self.uid = uid
        self.first_name = first_name
        self.last_name = last_name
        self.level = level
        self.classes = classes
        self.index = 0  # Initialize index for iteration

    def __iter__(self):
        self.index = 0  # Reset index for new iteration
        return self
    
    def __next__(self):
        # Increase index and return next class name while within bounds
        while self.index < len(self.classes):
            class_name = self.classes[self.index]
            self.index += 1
            return class_name
            
        # If index exceeds bounds, raise StopIteration
        raise StopIteration
        
    def add_class(self, class_name):
        self.classes.append(class_name)
        
    def __str__(self):
        # Create string representation of student information
        student_info = (
        f"UID: {self.uid}"
        f"\nFirst Name: {self.first_name}"
        f"\nLast Name: {self.last_name}"
        f"\nLevel: {self.level}"
        f"\nCLASSES:\n"
        )
        
        # Loop through class names and add to string
        for class_name in self.classes:
            student_info += f"{class_name}\n"
            
        student_info += "--------------------\n"
        student_info += "--------------------"
        
        # Write student information to output file
        output_file.write(student_info + "\n")
        
        return student_info
        
       

# MAIN PROGRAM -------------------------------------------------------------------------

if __name__ == "__main__":
    
    all_students = [] # List of all student objects
    header_text = "Student Records\n=================\n"
    
    try:
        input_file = open("studentRecordsIn.txt", "r") # Try to open input file
    except FileNotFoundError:
        print("studentRecordsIn.txt not found.\n Exiting...") # Print error message and exit program if file not found
        exit()
    # Read student records from input file
    with open("studentRecordsIn.txt", "r") as input_file:
        for line in input_file:
            words = line.strip().split() # Holds each word in record
            if words:
                uid = words[0]
                first_name = words[1]
                last_name = words[2]
                level = words[3]
                classes = []
                for i in range(4, len(words)):
                    classes.append(words[i])
                new_student = Student(uid, first_name, last_name, level, classes) # New student with record info
                all_students.append(new_student) # Add new student to list of all students
              
    # Add header text to output file  
    output_file.write(header_text)
    
    # Print header text to console
    print(header_text, end='')
    
    # Print all student records to console and send to output file
    for student in all_students:
        print(student) 
    
    # Close output file
    output_file.close()
