#pragma once
#include "Matrix.hpp"

template <typename T>
/**
 *	四元数
 *  如在这里的其他数学模型一样，支持旋转、缩放、点乘等基础操作，此外还可以转换成矢量或矩阵
 *  一个四元数（Quaternion）描述了一个旋转轴和一个旋转角度。
 *  当用一个四元数乘以一个向量时，实际上就是让该向量围绕着这个四元数所描述的旋转轴，转动这个四元数所描述的角度而得到的向量。
 */
struct QuaternionT {
    T x;
    T y;
    T z;
    T w;
    
    QuaternionT();
    QuaternionT(T x, T y, T z, T w);
    //插值
    QuaternionT<T> Slerp(T mu, const QuaternionT<T>& q) const;
    //旋转
    QuaternionT<T> Rotated(const QuaternionT<T>& b) const;
    //缩放
    QuaternionT<T> Scaled(T scale) const;
    //点乘
    T Dot(const QuaternionT<T>& q) const;
    Matrix3<T> ToMatrix() const;
    Vector4<T> ToVector() const;
    QuaternionT<T> operator-(const QuaternionT<T>& q) const;
    QuaternionT<T> operator+(const QuaternionT<T>& q) const;
    bool operator==(const QuaternionT<T>& q) const;
    bool operator!=(const QuaternionT<T>& q) const;
    
    void Normalize();
    void Rotate(const QuaternionT<T>& q);
    
    static QuaternionT<T> CreateFromVectors(const Vector3<T>& v0, const Vector3<T>& v1);
    static QuaternionT<T> CreateFromAxisAngle(const Vector3<T>& axis, float radians);
};

template <typename T>
inline QuaternionT<T>::QuaternionT() : x(0), y(0), z(0), w(1)
{
}

template <typename T>
inline QuaternionT<T>::QuaternionT(T x, T y, T z, T w) : x(x), y(y), z(z), w(w)
{
}

/**
 *	球状线性插值
 *  球状线性插值对于三位模型进行动画处理非常有用，因为这种方式在模型的各种方向之间提供了平滑的转换。
 *  注 ： Ken Shoemake 是把四元数引入3D编程界的大牛
 *	@param	t	插值参数
 *	@param	v1	插值前的矩阵
 *
 *	@return	插值后的矩阵
 */
// Ken Shoemake's famous method.
template <typename T>
inline QuaternionT<T> QuaternionT<T>::Slerp(T t, const QuaternionT<T>& v1) const
{
    const T epsilon = 0.0005f;
    T dot = Dot(v1);
    
    if (dot > 1 - epsilon) {
        QuaternionT<T> result = v1 + (*this - v1).Scaled(t);
        result.Normalize();
        return result;
    }
    
    if (dot < 0)
        dot = 0;
    
    if (dot > 1)
        dot = 1;
    
    T theta0 = std::acos(dot);
    T theta = theta0 * t;
    
    QuaternionT<T> v2 = (v1 - Scaled(dot));
    v2.Normalize();
    
    QuaternionT<T> q = Scaled(std::cos(theta)) + v2.Scaled(std::sin(theta));
	q.Normalize();
	return q;
}

template <typename T>
inline QuaternionT<T> QuaternionT<T>::Rotated(const QuaternionT<T>& b) const
{
    QuaternionT<T> q;
    q.w = w * b.w - x * b.x - y * b.y - z * b.z;
    q.x = w * b.x + x * b.w + y * b.z - z * b.y;
    q.y = w * b.y + y * b.w + z * b.x - x * b.z;
    q.z = w * b.z + z * b.w + x * b.y - y * b.x;
    q.Normalize();
    return q;
}

template <typename T>
inline QuaternionT<T> QuaternionT<T>::Scaled(T s) const
{
    return QuaternionT<T>(x * s, y * s, z * s, w * s);
}

template <typename T>
inline T QuaternionT<T>::Dot(const QuaternionT<T>& q) const
{
    return x * q.x + y * q.y + z * q.z + w * q.w;
}

template <typename T>
inline Matrix3<T> QuaternionT<T>::ToMatrix() const
{
    const T s = 2;
    T xs, ys, zs;
    T wx, wy, wz;
    T xx, xy, xz;
    T yy, yz, zz;
    xs = x * s;  ys = y * s;  zs = z * s;
    wx = w * xs; wy = w * ys; wz = w * zs;
    xx = x * xs; xy = x * ys; xz = x * zs;
    yy = y * ys; yz = y * zs; zz = z * zs;
    Matrix3<T> m;
    m.x.x = 1 - (yy + zz); m.y.x = xy - wz;  m.z.x = xz + wy;
    m.x.y = xy + wz; m.y.y = 1 - (xx + zz); m.z.y = yz - wx;
    m.x.z = xz - wy; m.y.z = yz + wx;  m.z.z = 1 - (xx + yy);
    return m;
}

template <typename T>
inline Vector4<T> QuaternionT<T>::ToVector() const
{
    return Vector4<T>(x, y, z, w);
}

template <typename T>
QuaternionT<T> QuaternionT<T>::operator-(const QuaternionT<T>& q) const
{
    return QuaternionT<T>(x - q.x, y - q.y, z - q.z, w - q.w);
}

template <typename T>
QuaternionT<T> QuaternionT<T>::operator+(const QuaternionT<T>& q) const
{
    return QuaternionT<T>(x + q.x, y + q.y, z + q.z, w + q.w);
}

template <typename T>
bool QuaternionT<T>::operator==(const QuaternionT<T>& q) const
{
    return x == q.x && y == q.y && z == q.z && w == q.w;
}

template <typename T>
bool QuaternionT<T>::operator!=(const QuaternionT<T>& q) const
{
    return !(*this == q);
}

/**
 * 就是通过向量来构造四元数啦
 * Compute the quaternion that rotates from a to b, avoiding numerical instability.
 * Taken from "The Shortest Arc Quaternion" by Stan Melax in "Game Programming Gems".
 */
template <typename T>
inline QuaternionT<T> QuaternionT<T>::CreateFromVectors(const Vector3<T>& v0, const Vector3<T>& v1)
{
    if (v0 == -v1)
        return QuaternionT<T>::CreateFromAxisAngle(vec3(1, 0, 0), Pi);
    
    Vector3<T> c = v0.Cross(v1);
    T d = v0.Dot(v1);
    T s = std::sqrt((1 + d) * 2);

    QuaternionT<T> q;
    q.x = c.x / s;
    q.y = c.y / s;
    q.z = c.z / s;
    q.w = s / 2.0f;
    return q;
}

/**
 *	指定一个角度一个旋转轴来构造一个Quaternion。这个角度是相对于单位四元数而言的，也可以说是相对于物体的初始方向而言的。
 *
 *	@param	axis	旋转轴
 *	@param	radians	角度(弧度制)
 */
template <typename T>
inline QuaternionT<T>  QuaternionT<T>::CreateFromAxisAngle(const Vector3<T>& axis, float radians)
{
    QuaternionT<T> q;
    q.w = std::cos(radians / 2);
    q.x = q.y = q.z = std::sin(radians / 2);
    q.x *= axis.x;
    q.y *= axis.y;
    q.z *= axis.z;
    return q;
}

/**
 *	四元数多次运算后会积攒误差，需要对其做规范化
 */
template <typename T>
inline void QuaternionT<T>::Normalize()
{
    *this = Scaled(1 / std::sqrt(Dot(*this)));
}

template <typename T>
inline void QuaternionT<T>::Rotate(const QuaternionT<T>& q2)
{
    QuaternionT<T> q;
    QuaternionT<T>& q1 = *this;
    
    q.w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
    q.x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
    q.y = q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z;
    q.z = q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x;
    
    q.Normalize();
    *this = q;
}

typedef QuaternionT<float> Quaternion;
