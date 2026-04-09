def remove_duplicates(input_string):
    """
    Given a string, remove all the duplicates and print the unique string. 
    Use loop in the python.
    """
    result = ""
    for char in input_string:
        if char not in result:
            result += char
    return result

if __name__ == "__main__":
    sample1 = "hello world"
    print(f"Original: '{sample1}' -> Unique: '{remove_duplicates(sample1)}'")
    
    sample2 = "programming"
    print(f"Original: '{sample2}' -> Unique: '{remove_duplicates(sample2)}'")
