# Josiah Schmitz


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
        f"\nCLASSES:"
        )
        
        # Loop through class names and add to string
        for class_name in self.classes:
            student_info += f"\n{class_name}"
        
        return student_info
        
       

# MAIN PROGRAM -------------------------------------------------------------------------

if __name__ == "__main__":
    
    test_student = Student("666", "John", "Doe", "Undergrad", ["CS3180", "CEG2170"])
    
    for class_name in test_student:
        print(class_name)
    
    print(test_student)