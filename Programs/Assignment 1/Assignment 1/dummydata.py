import names
from faker import Faker
import random

fake = Faker()

def generate_base_data():

    data = ''

    data += names.get_first_name().ljust(12)[:12]
    data += names.get_last_name().ljust(12)[:12]
    
    address = fake.address().split('\n')
    street = address[0]
    address = address[1].split(',')
    city = address[0]
    state = address[1][1:3]

    data += street.ljust(15)[:15]
    data += city.ljust(13)[:13]
    data += state.ljust(2)[:2]

    return data

def generate_good_data():
    f = open('good.txt', 'w')
    for i in range(10):
        data = generate_base_data()
        
        account_number = random.randint(0,999999)
        prev_meter_reading = random.randint(0,99999)
        curr_meter_reading = random.randint(prev_meter_reading, 99999)
        
        data += str(account_number).ljust(6)
        data += str(prev_meter_reading).ljust(5)
        data += str(curr_meter_reading).ljust(5)
        data += '\n'
        
        f.write(data)

if __name__ == '__main__':
    generate_good_data()