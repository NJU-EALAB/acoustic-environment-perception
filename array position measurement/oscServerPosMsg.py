"""Small example OSC server

This program listens to several addresses, and prints some information about
received packets.
"""
import argparse
import math
import socket
import json

from pythonosc import dispatcher
from pythonosc import osc_server

def print_handler(unused_addr, args, *recData):
  try:
    print("[{0}] ~ {1}".format(args[0], recData))
  except ValueError: pass

def udp_handler(unused_addr, args, *recData):
  MESSAGE = json.dumps(recData)+'\r\n'
  args[0].sendto(MESSAGE.encode(), (args[1], args[2]))

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip",
#      default='127.0.0.1', help="The ip to listen on")
     default="192.168.1.104", help="The ip to listen on")
  parser.add_argument("--port",
      type=int, default=5005, help="The port to listen on")
  args = parser.parse_args()

  dispatcher = dispatcher.Dispatcher()
  dispatcher.map("/micArray/serialData", print_handler,"serial data")

  sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  dispatcher.map("/micArray/serialData", udp_handler,sock,'127.0.0.1',5006)

  server = osc_server.ThreadingOSCUDPServer(
      (args.ip, args.port), dispatcher)
  print("Serving on {}".format(server.server_address))
  server.serve_forever()