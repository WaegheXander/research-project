from flask import Flask, render_template, request, redirect, url_for
import os

# from scapy.all import rdpcap
# import pandas as pd

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER


# def analyze_bandwidth(cap_file_path):
#     # Read the pcap file
#     packets = rdpcap(cap_file_path)

#     # Extract relevant information from packets
#     data = []
#     for packet in packets:
#         if "IP" in packet and "TCP" in packet:
#             timestamp = packet.time
#             source_ip = packet["IP"].src
#             destination_ip = packet["IP"].dst
#             packet_size = len(packet)
#             duration = (
#                 packet.time - packets[0].time
#             )  # Assuming the first packet is the start time

#             data.append((timestamp, source_ip, destination_ip, packet_size, duration))

#     # Create a DataFrame using pandas
#     columns = ["timestamp", "source_ip", "destination_ip", "packet_size", "duration"]
#     df = pd.DataFrame(data, columns=columns)

#     # Sort DataFrame by timestamp
#     df = df.sort_values(by="timestamp")

#     # Calculate data transfer rates
#     df["data_transfer_rate"] = df.apply(
#         lambda row: row["packet_size"] / row["duration"] if row["duration"] != 0 else 0,
#         axis=1,
#     )

#     # Calculate total data transfer for each IP address
#     total_data_transfer = df.groupby("source_ip")["packet_size"].sum().reset_index()

#     return df, total_data_transfer


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return redirect(request.url)

    file = request.files["file"]

    if file.filename == "":
        return redirect(request.url)

    if file:
        filename = os.path.join(app.config["UPLOAD_FOLDER"], file.filename)
        file.save(filename)
        return "File uploaded successfully!"


# @app.route("/analyze/bandwidth")
# def display_bandwidth_analysis():
#     cap_file_path = "Tests/test.cap"  # Replace with the path to your .cap file
#     df, total_data_transfer = analyze_bandwidth(cap_file_path)

#     # Render the results on a webpage
#     return render_template(
#         "bandwidth_analysis.html", df=df, total_data_transfer=total_data_transfer
#     )


if __name__ == "__main__":
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    app.run(debug=True)
