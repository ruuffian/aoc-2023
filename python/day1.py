def convert_cal_value(calibration_value: str) -> str:
    mapping = {"one":"1", "two":"2", "three":"3", "four":"4", "five":"5", "six":"6", "seven":"7", "eight":"8", "nine":"9"}
    start = 0
    i = 1
    while [calibration_value for key in mapping.keys() if(key in calibration_value)]:
        test = calibration_value[start:i]
        if [test for key in mapping.keys() if(key in test)]:
            test = [key for key in mapping.keys() if(key in test)][0]
            calibration_value = calibration_value.replace(test, mapping[test])
            start = i - len(test) + 1
            i = start
        i += 1

    return calibration_value

def find_cal_val(calibration_value):
    first = last = "0"
    length = len(calibration_value)
    for i in range(len(calibration_value)):
        if first == "0" and calibration_value[i] in "123456789":
            first = calibration_value[i]
        if last == "0" and calibration_value[length - i - 1] in "123456789":
            last = calibration_value[length - i - 1]
    return int(first + last)

def main():
    values = open("../inputs/day1.txt").read().split("\n")
    total = 0
    for value in values:
        total += find_cal_val(value)
    print("Part 1:", total)

    total = 0
    for value in values:
        total += find_cal_val(convert_cal_value(value))
    print("Part 2:", total)

if __name__ == "__main__":
    main()