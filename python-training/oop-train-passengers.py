def booking_process_decorator(f):
    def wrapper(*args, **kwargs):
        print("Starting the train booking process...")
        result = f(*args, **kwargs)
        print("Train booking process completed.")
        return result
    return wrapper

class Train():
    def __init__(self, capacity):
        self.capacity = capacity
        self.passengers = {}  # Change to dictionary

    def add_passenger(self, name, number):
        if len(self.passengers) < self.capacity:
            self.passengers[name] = number  # Add to dictionary
            print(f"Passenger {name} added with ticket number {number}.")
            proceed = input("Do you want to add another passenger? (yes/no): ")
            if proceed.lower() == 'yes' or proceed.lower() == 'y':
                new_name = input("Enter passenger name: ")
                new_number = input("Enter ticket number: ")
                self.add_passenger(new_name, new_number)
        else:
            print("Train is full")
            return False
        

    def show_passengers(self):
        print("Passengers on the train:")
        for name, number in self.passengers.items():
            print(f"Name: {name}, Ticket Number: {number}")

@booking_process_decorator
def run_booking():
    try:
        capacity = int(input("Enter train capacity: "))
    except ValueError:
        print("Invalid capacity. Exiting.")
        exit(1)
    train = Train(capacity)
    name = input("Enter passenger name: ")
    number = input("Enter ticket number: ")
    train.add_passenger(name, number)
    show_passengers = input("Do you want to see the list of passengers? (yes/no): ")
    if show_passengers.lower() == 'yes' or show_passengers.lower() == 'y':
        train.show_passengers()
    else:
        print("Thank you!")

if __name__ == "__main__":
    run_booking()