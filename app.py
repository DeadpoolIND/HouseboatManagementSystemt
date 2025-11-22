from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import psycopg2
import psycopg2.extras
import os

DB_NAME = os.getenv("DB_NAME", "houseboat_db")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "postgres")
DB_HOST = os.getenv("DB_HOST", "127.0.0.1")
DB_PORT = os.getenv("DB_PORT", "5432")

app = Flask(__name__, static_folder="static", static_url_path="/")
CORS(app, resources={r"/api/*": {"origins": "*"}})

def get_conn():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST,
        port=DB_PORT
    )

def dict_rows(cur):
    return [dict(row) for row in cur.fetchall()]

@app.route("/api/owners", methods=["GET"])
def get_owners():
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute("SELECT owner_id AS id, owner_name AS name, date_of_birth AS dob, license_no FROM owners ORDER BY owner_id")
            return jsonify(cur.fetchall())

@app.route("/api/owners", methods=["POST"])
def create_owner():
    data = request.json
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO owners (owner_name, date_of_birth, license_no)
                VALUES (%s, %s, %s)
                RETURNING owner_id
            """, (data.get("owner_name"), data.get("date_of_birth"), data.get("license_no")))
            owner_id = cur.fetchone()[0]
            conn.commit()
            return jsonify({"id": owner_id}), 201

@app.route("/api/owners/<int:owner_id>", methods=["DELETE"])
def delete_owner(owner_id):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM owners WHERE owner_id = %s", (owner_id,))
            conn.commit()
            return "", 204

@app.route("/api/services", methods=["GET"])
def get_services():
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute("SELECT service_id AS id, service_type, wifi_bandwidth, cuisine, has_bar, rate FROM services ORDER BY service_id")
            return jsonify(cur.fetchall())

@app.route("/api/services", methods=["POST"])
def create_service():
    data = request.json
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO services (service_type, wifi_bandwidth, cuisine, has_bar, rate)
                VALUES (%s, %s, %s, %s, %s) RETURNING service_id
            """, (data.get("service_type"), data.get("wifi_bandwidth"), data.get("cuisine"), data.get("has_bar", False), data.get("rate")))
            sid = cur.fetchone()[0]
            conn.commit()
            return jsonify({"id": sid}), 201

@app.route("/api/services/<int:sid>", methods=["DELETE"])
def delete_service(sid):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM services WHERE service_id = %s", (sid,))
            conn.commit()
            return "", 204

@app.route("/api/boats", methods=["GET"])
def get_boats():
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute("""
                SELECT b.boat_id AS id, b.boat_number, b.boat_capacity AS capacity,
                       b.owner_id, o.owner_name AS owner_name,
                       b.service_id, s.service_type AS service_type
                FROM boats b
                LEFT JOIN owners o ON b.owner_id = o.owner_id
                LEFT JOIN services s ON b.service_id = s.service_id
                ORDER BY b.boat_id
            """)
            return jsonify(cur.fetchall())

@app.route("/api/boats", methods=["POST"])
def create_boat():
    data = request.json
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO boats (boat_number, boat_capacity, owner_id, service_id)
                VALUES (%s, %s, %s, %s) RETURNING boat_id
            """, (data.get("boat_number"), data.get("capacity"), data.get("owner_id"), data.get("service_id")))
            bid = cur.fetchone()[0]
            conn.commit()
            return jsonify({"id": bid}), 201

@app.route("/api/boats/<int:bid>", methods=["DELETE"])
def delete_boat(bid):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM boats WHERE boat_id = %s", (bid,))
            conn.commit()
            return "", 204

@app.route("/api/clients", methods=["GET"])
def get_clients():
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute("SELECT client_id AS id, first_name, last_name, client_city AS city, client_country AS country, date_of_birth AS dob FROM clients ORDER BY client_id")
            return jsonify(cur.fetchall())

@app.route("/api/clients", methods=["POST"])
def create_client():
    data = request.json
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO clients (first_name, last_name, client_city, client_country, date_of_birth)
                VALUES (%s, %s, %s, %s, %s) RETURNING client_id
            """, (data.get("first_name"), data.get("last_name"), data.get("city"), data.get("country"), data.get("dob")))
            cid = cur.fetchone()[0]
            phones = data.get("phone_numbers") or ( [data.get("phone")] if data.get("phone") else [] )
            for p in phones:
                if p:
                    cur.execute("INSERT INTO client_phone_numbers (client_id, phone_number) VALUES (%s, %s)", (cid, p))
            conn.commit()
            return jsonify({"id": cid}), 201

@app.route("/api/clients/<int:cid>", methods=["DELETE"])
def delete_client(cid):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM clients WHERE client_id = %s", (cid,))
            conn.commit()
            return "", 204

@app.route("/api/routes", methods=["GET"])
def get_routes():
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute("SELECT route_id AS id, source, destination FROM routes ORDER BY route_id")
            routes = cur.fetchall()
            for r in routes:
                cur.execute("SELECT spot_name FROM route_spots WHERE route_id = %s ORDER BY spot_order NULLS LAST, route_spot_id", (r['id'],))
                r['spots'] = [row['spot_name'] for row in cur.fetchall()]
            return jsonify(routes)

@app.route("/api/routes", methods=["POST"])
def create_route():
    data = request.json
    spots = data.get("spots") or []
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO routes (source, destination) VALUES (%s, %s) RETURNING route_id", (data.get("source"), data.get("destination")))
            rid = cur.fetchone()[0]
            for idx, s in enumerate(spots):
                cur.execute("INSERT INTO route_spots (route_id, spot_name, spot_order) VALUES (%s, %s, %s)", (rid, s, idx))
            conn.commit()
            return jsonify({"id": rid}), 201

@app.route("/api/routes/<int:rid>", methods=["DELETE"])
def delete_route(rid):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM routes WHERE route_id = %s", (rid,))
            conn.commit()
            return "", 204

@app.route("/api/bookings", methods=["GET"])
def get_bookings():
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute("""
                SELECT b.booking_id AS id, b.client_id, c.first_name AS client_first, c.last_name AS client_last,
                       b.boat_id, bt.boat_number,
                       b.route_id, r.source AS route_source, r.destination AS route_destination,
                       b.from_date, b.to_date, b.payment_type, b.payment_status, b.payment_amount
                FROM bookings b
                LEFT JOIN clients c ON b.client_id = c.client_id
                LEFT JOIN boats bt ON b.boat_id = bt.boat_id
                LEFT JOIN routes r ON b.route_id = r.route_id
                ORDER BY b.booking_id
            """)
            return jsonify(cur.fetchall())

@app.route("/api/bookings", methods=["POST"])
def create_booking():
    data = request.json
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO bookings (client_id, boat_id, route_id, from_date, to_date, payment_type, payment_status, payment_amount)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s) RETURNING booking_id
            """, (data.get("client_id"), data.get("boat_id"), data.get("route_id"),
                  data.get("from_date"), data.get("to_date"), data.get("payment_type"),
                  data.get("payment_status"), data.get("payment_amount")))
            bid = cur.fetchone()[0]
            conn.commit()
            return jsonify({"id": bid}), 201

@app.route("/api/bookings/<int:bid>", methods=["DELETE"])
def delete_booking(bid):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM bookings WHERE booking_id = %s", (bid,))
            conn.commit()
            return "", 204

@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve_frontend(path):
    if path != "" and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, "index.html")

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.getenv("PORT", 5000)))
