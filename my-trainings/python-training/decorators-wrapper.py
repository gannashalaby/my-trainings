def train_passenger_decorator(func):
    def wrapper(*args, **kwargs):
        print("Welcome to the Train Booking System!")
        result = func(*args, **kwargs)
        print("Thank you for using the Train Booking System!")
        return result
    return wrapper

@train_passenger_decorator
def add_passenger_to_train(train, name):
    if len(train['passengers']) < train['capacity']:
        train['passengers'].append(name)
        print(f"Passenger {name} added")
        return True
    else:
        print("Train is full")
        return False
    
add_passenger_to_train({'capacity': 3, 'passengers': []}, 'Alice')