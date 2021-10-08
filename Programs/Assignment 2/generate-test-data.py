from faker import Faker
from faker_vehicle import VehicleProvider
import string
import random


fake = Faker()
fake.add_provider(VehicleProvider)


class Data:

    def __init__(self):
        self.location = fake.city() if random.randint(0,100) > 1 else ''
        self.branch = random.randint(0,9999) if random.randint(0,100) > 1 else ''
        self.salesperson = fake.last_name() if random.randint(0,100) > 1 else '' 
        self.customer = fake.last_name() if random.randint(0,100) > 1 else ''
        self.sales_date = int( str(random.randint(1,12)).rjust(2,'0') + str(random.randint(0,28)).rjust(2,'0') + str(random.randint(90,95)).rjust(2,'0') )
        self.sales_amount = random.randint(0,999999) if random.randint(0,100) > 1 else ''
        self.commission_rate = random.randint(0, 100) if random.randint(0,100) > 1 else ''
        self.car_model = fake.vehicle_make_model()
        self.car_year = random.randint(1990,1995) if random.randint(0,100) > 1 else ''
        self.corrupt_data()

    
    def fit_str_to_length(self, input_data: str, length, padding):
        return input_data[:length] if len(input_data) > length else input_data.ljust(length, padding)


    def corrupt_data(self):
        if random.randint(0,99) < 1:
            self.branch = 'asd'
        if random.randint(0,99) < 1:
            self.sales_date = 'asdfga'
        if random.randint(0,99) < 1:
            self.sales_amount = 'abc'
        if random.randint(0,99) < 1:
            self.commission_rate = 'xyz'
        if random.randint(0,99) < 1:
            self.sales_date = int( str(random.randint(0,99)).rjust(2,'0') + str(random.randint(0,99)).rjust(2,'0') + str(random.randint(0,99)).rjust(2,'0') )
        if random.randint(0,99) > 99:
            self.commission_rate = random.randint(0,999)
        if random.randint(0,99) < 1:
            self.car_year = random.randint(0, 9999)


    def __str__(self):
        data_string = ''

        data_string += self.fit_str_to_length(self.location, 11, ' ')
        data_string += str(self.branch).rjust(4,'0')
        data_string += self.fit_str_to_length(self.salesperson, 10, ' ')
        data_string += self.fit_str_to_length(self.customer, 10, ' ')
        data_string += str(self.sales_date).rjust(6,'0')
        data_string += str(self.sales_amount).rjust(6,'0')
        data_string += str(self.commission_rate).rjust(3,'0')
        data_string += self.fit_str_to_length(self.car_model, 13, ' ')
        data_string += str(self.car_year).rjust(4, '0')

        return data_string


if __name__ == '__main__':

    output_file = open('test-data.txt', 'w')
    
    for i in range(1000):
        output_file.write(str(Data())+'\n')

    output_file.close()
