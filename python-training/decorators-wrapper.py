def train_passenger_decorator(func):
    def wrapper(*args, **kwargs):
        print("Welcome to the Train Booking System!")
        result = func(*args, **kwargs)
        print("Thank you for using the Train Booking System!")
        return result
    return wrapper

def add_passenger_to_train(train, name):
    if len(train['passengers']) < train['capacity']:
        train['passengers'].append(name)
        print(f"Passenger {name} added")
        return True
    else:
        print("Train is full")
        return False
    
@train_passenger_decorator
def main():
    train = {'capacity': 2, 'passengers': []}
    while True:
        name = input("Enter passenger name (or 'exit' to stop): ")
        if name.lower() == 'exit':
            break
        if not add_passenger_to_train(train, name):
            break
    print("Final list of passengers:", train['passengers'])

if __name__ == "__main__":
    main()