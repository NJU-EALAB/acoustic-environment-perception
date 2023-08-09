# -*- coding: utf-8 -*-
import threading
import serial
from pythonosc import udp_client
import math
import Math
import time

class foreverThread (threading.Thread):
    def __init__(self, target, lock):
        threading.Thread.__init__(self)
        self.target = target
        self.lock = lock
    def run(self):
        while True:
            self.lock.acquire()
            try:
                self.target()
#            except:
#                print('error in self.target()')
            finally:
                self.lock.release()
                print('',end='')# do not delete

def getGyroscopeMsg():
    global data
    try:
        data0 = serGyro.readline().decode().split(',')
        data0 = [float(i) for i in data0]
        data = data0
    except:
        print('error in self.target()')
def getUWBMsg():
    global dataUWB
    dataUWB0 = serUWB.readline().decode().split(' ')
    if dataUWB0[0]=='mc':
        # [tagName,mask,range1,range2,range3,range4] (unit:mm)
        tagName = dataUWB0[9].split(':')
        tagRange = [int(dataUWB0[2],16),int(dataUWB0[3],16),int(dataUWB0[4],16),int(dataUWB0[5],16)]
        tagRange = [min(i,1000000) for i in tagRange]
        dataUWB = [tagName[0],int(dataUWB0[1],16)]+tagRange


# add lock
lock1 = threading.Lock()
lock2 = threading.Lock()
# 创建新线程
thread1 = foreverThread(getGyroscopeMsg, lock1)
thread2 = foreverThread(getUWBMsg, lock2)

"""定义初值"""
interval_time = 0.001 # 发送间隔
    
serGyro = serial.Serial('/dev/ttyUSB0', 57600, timeout=0.5)  # 打开串口
# ser = serial.Serial('COM3', 57600, timeout=0.5)  # 打开串口
serUWB = serial.Serial('/dev/ttyUSB1', 115200, timeout=0.5)  # 打开UWB串口

client = udp_client.SimpleUDPClient('192.168.1.104', 5005)

# 开启新线程
thread1.start()
thread2.start()
time.sleep(1)

lock1.acquire()
e0 = data[3:6]  # 初始欧拉角
lock1.release()

"""循环发送状态"""
while True:
    lock1.acquire()
    a = data[0:3]  # 加速度
    e = data[3:6]  # 欧拉角（roll,,pitch,yaw）单位（度）
    lock1.release()
    lock2.acquire()
    r = dataUWB
    lock2.release()
    
    try:
        ypr = Math.ypr(e, e0)
        yaw = ypr[2]
    except:
        print('error in Math.ypr(e, e0)')

    outData = r+[yaw]
    print('\r', outData, '                               ',end='')
    client.send_message("/micArray/serialData", outData)

    time.sleep(interval_time)






