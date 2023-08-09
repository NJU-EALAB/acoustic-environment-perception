#websocket_client文件的一部分
#定义四元数和旋转的相关操作

import math

"""四元数旋转"""
def rot(q,a,err):
    s = q[0]
    v = q[1:4]
    norm2_v = v[0] * v[0] + v[1] * v[1] + v[2] * v[2]
    vxa = [v[1] * a[2] - v[2] * a[1], v[2] * a[0] - v[0] * a[2], v[0] * a[1] - v[1] * a[0]]
    va = v[0] * a[0] + v[1] * a[1] + v[2] * a[2]

    a_rot = [round((s * s - norm2_v) * a[i] + 2 * s * vxa[i] + 2 * va * v[i],err) for i in range(3)]
    return a_rot

"""根据欧拉角产生四元数"""
def quater(e,err):
    roll = math.pi*e[0]/180
    pitch = math.pi*e[1]/180
    yaw = math.pi*e[2]/180
    q = [0,0,0,0]

    cy = math.cos(yaw * 0.5)
    sy = math.sin(yaw * 0.5)
    cp = math.cos(pitch * 0.5)
    sp = math.sin(pitch * 0.5)
    cr = math.cos(roll * 0.5)
    sr = math.sin(roll * 0.5)

    q[0] = round(cy * cp * cr + sy * sp * sr,err)
    q[1] = round(cy * cp * sr - sy * sp * cr,err)
    q[2] = round(sy * cp * sr + cy * sp * cr,err)
    q[3] = round(sy * cp * cr - cy * sp * sr,err)
    return q

"""四元数的逆"""
def inv(q):
    q_inv = [q[0],-q[1],-q[2],-q[3]]
    return q_inv

"""四元数运算"""
def q_dot(q1,q2):
    q = [0 for i in range(4)]
    s1 = q1[0]
    v1 = q1[1:4]
    s2 = q2[0]
    v2 = q2[1:4]

    v1v2 = v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2]
    v1xv2 = [v1[1] * v2[2] - v1[2] * v2[1], v1[2] * v2[0] - v1[0] * v2[2], v1[0] * v2[1] - v1[1] * v2[0]]

    q[0] = s1*s2 - v1v2
    q[1:4] = [s1*v2[i]+s2*v1[i]+v1xv2[i] for i in range(3)]
    return q

"""相对欧拉角"""
def ypr(e,e0):

    yaw = round(e0[2] - e[2], 0)  # 欧拉角的相对转动

    if yaw > 180:
        yaw = yaw - 360
    elif yaw < -180:
        yaw = yaw + 360

    roll = round(e0[0] - e[0], 0)
    if roll > 180:
        roll = roll - 360
    elif roll < -180:
        roll = roll + 360

    pitch = round(e0[1] - e[1], 0)
    if pitch > 180:
        pitch = pitch - 360
    elif yaw < -180:
        pitch = pitch + 360

    return [roll,pitch,yaw]

