def convert_minutes(minutes):
    """
    Given number of minutes, convert it into human readable form.
    Example :
    130 becomes “2 hrs 10 minutes”
    110 becomes “1hr 50minutes”
    """
    try:
        minutes = int(minutes)
    except ValueError:
        return "Invalid input"

    if minutes < 0:
        return "Minutes cannot be negative"

    hours = minutes // 60
    remaining_minutes = minutes % 60

    hour_str = "hr" if hours == 1 else "hrs"
    
    if hours == 0:
        return f"{remaining_minutes} minutes"
    elif remaining_minutes == 0:
        return f"{hours} {hour_str}"
    else:
        return f"{hours} {hour_str} {remaining_minutes} minutes"

if __name__ == "__main__":
    print(convert_minutes(130))  # Output: 2 hrs 10 minutes
    print(convert_minutes(110))  # Output: 1 hr 50 minutes
    print(convert_minutes(45))   # Output: 45 minutes
