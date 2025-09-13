capacity = input("Enter train capacity: ")
passengerName = input("Enter passenger name: ")
passengers = []

class Train():
    def __init__(self, capacity):
            self.capacity = capacity

    def add_passenger(self, name):
            if len(passengers) < self.capacity:
                passengers.append(name)
                print(f"Passenger {name} added")
                proceed = input("Do you want to add another passenger? (yes/no): ")
                if proceed.lower() == 'yes' or proceed.lower() == 'y':
                    new_name = input("Enter passenger name: ")
                    self.add_passenger(new_name)
                return True
            else:
                print("Train is full")
                return False

Train(int(capacity)).add_passenger(passengerName)

show_passengers = input("Do you want to see the list of passengers? (yes/no): ")
if show_passengers.lower() == 'yes'or show_passengers.lower() == 'y':
    train = Train(int(capacity))
    print("Passengers on the train:", passengers)
else:
    print("Thank you!")