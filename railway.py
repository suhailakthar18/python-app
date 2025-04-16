from flask import session

class Railway:
    def __init__(self, mysql, train_no, departure_time, source, destination):
        self.mysql = mysql
        self.train_no = train_no
        self.departure_time = departure_time
        self.source = source
        self.destination = destination

    def book(self):
        cur = self.mysql.connection.cursor()
        cur.execute("""
            INSERT INTO bookings (train_no, departure_time, source, destination, username)
            VALUES (%s, %s, %s, %s, %s)
        """, (self.train_no, self.departure_time, self.source, self.destination, session["user"]))
        self.mysql.connection.commit()
        cur.close()
        return f"Booking confirmed for train {self.train_no} from {self.source} to {self.destination} at {self.departure_time}."

    def status(self):
        cur = self.mysql.connection.cursor()
        cur.execute("""
            SELECT * FROM bookings
            WHERE train_no = %s AND username = %s
        """, (self.train_no, session["user"]))
        booking = cur.fetchone()
        cur.close()
        if booking:
            return f"Booking exists for train {self.train_no} at {booking[2]} from {booking[3]} to {booking[4]}."
        else:
            return "No booking found for this train."

    def fare(self):
        # Simple dummy fare logic based on distance or random value
        base_fare = 100
        fare = base_fare + len(self.source + self.destination) * 2
        return f"Estimated fare from {self.source} to {self.destination} is ₹{fare}."

