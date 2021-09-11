import names
from faker import Faker
import random
import string

fake = Faker()

def generate_base_data():

    data = ''

    data += names.get_first_name().ljust(12)[:12]
    data += names.get_last_name().ljust(12)[:12]

    data += fake.street_address().ljust(15)[:15]
    data += fake.city().ljust(13)[:13]
    data += fake.state().ljust(2)[:2]

    return data


def generate_good_data():
    f = open('good.txt', 'w')
    for i in range(1000):
        data = generate_base_data()
        
        account_number = random.randint(0,999999)
        prev_meter_reading = random.randint(0,99999)
        curr_meter_reading = random.randint(prev_meter_reading, 99999)
        
        data += str(account_number).ljust(6)
        data += str(prev_meter_reading).ljust(5)
        data += str(curr_meter_reading).ljust(5)
        data += '\n'
        
        f.write(data)
    f.close()


def generate_bad_data():
    f = open('bad.txt', 'w')
    for i in range(1000):
        data = generate_base_data()
        
        account_number = random.randint(100000,999999)
        prev_meter_reading = random.randint(10000,99999)
        curr_meter_reading = random.randint(prev_meter_reading, 99999)
        
        # Corrupt the data - approximately 3% of data will have an anomaly
        chance = random.randint(0,32)

        if chance == 0:
            account_number = gen_random_string(6)
        if chance == 1:
            prev_meter_reading = gen_random_string(5)
        if chance == 2:
            curr_meter_reading = gen_random_string(5)
        

        data += str(account_number).ljust(6)
        data += str(prev_meter_reading).ljust(5)
        data += str(curr_meter_reading).ljust(5)
        data += '\n'
        
        f.write(data)
    f.close()


def gen_random_string(size):
    return ''.join(random.choice(string.ascii_uppercase + string.ascii_lowercase + string.digits) for _ in range(size))


if __name__ == '__main__':
    generate_good_data()
    generate_bad_data()