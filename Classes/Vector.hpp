/**
 *  @file
 *  该文件定义了2维至4维的矢量，并且typedef成"类型名+vec+维数"的形式
 */
#pragma once
#include <cmath>
using namespace std;
/**
 *	Pi 值
 */
const double Pi = 4 * std::atan(1.0f);
const double TwoPi = 2 * Pi;

template <typename T>
/**
 *	二维矢量
 */
struct Vector2 {
    Vector2() {}
    Vector2(T x, T y) : x(x), y(y) {}
    
    /**
     *  点乘
     */
    T Dot(const Vector2& v) const
    {
        return x * v.x + y * v.y;
    }
    Vector2 operator+(const Vector2& v) const
    {
        return Vector2(x + v.x, y + v.y);
    }
    Vector2 operator-(const Vector2& v) const
    {
        return Vector2(x - v.x, y - v.y);
    }
    Vector2 operator/(float s) const
    {
        return Vector2(x / s, y / s);
    }
    Vector2 operator*(float s) const
    {
        return Vector2(x * s, y * s);
    }
    
    /**
     *  单位化
     */
    void Normalize()
    {
        float s = 1.0f / Length();
        x *= s;
        y *= s;
    }
    Vector2 Normalized() const 
    {
        Vector2 v = *this;
        v.Normalize();
        return v;
    }
    
    /**
     *  返回长度的平方
     */
    T LengthSquared() const
    {
        return x * x + y * y;
    }
    T Length() const
    {
        return sqrt(LengthSquared());
    }
    
    operator Vector2<float>() const
    {
        return Vector2<float>(x, y);
    }
    bool operator==(const Vector2& v) const
    {
        return x == v.x && y == v.y;
    }
    
    /**
     *	返回本矢量和指定矢量之间的一个矢量
     *
     *	@param	t	比例系数
     *	@param	v	结束矢量
     *
     *	@return	新的矢量
     */
    Vector2 Lerp(float t, const Vector2& v) const
    {
        return Vector2(x * (1 - t) + v.x * t,
                       y * (1 - t) + v.y * t);
    }
    
    /**
     *	将任意类型数据写入向量
     *
     *	@param	pData	将要写入的数据
     *
     *	@return	写入的数据的类型的指针，指向向量的下一个内存位置
     */
    template <typename P>
    P* Write(P* pData)
    {
        Vector2* pVector = (Vector2*) pData;
        *pVector++ = *this;
        return (P*) pVector;
    }
    
    T x;
    T y;
};

template <typename T>
/**
 *	三维矢量
 */
struct Vector3 {
    Vector3() {}
    Vector3(T x, T y, T z) : x(x), y(y), z(z) {}
    
    /**
     *	单位化
     */
    void Normalize()
    {
        float s = 1.0f / std::sqrt(x * x + y * y + z * z);
        x *= s;
        y *= s;
        z *= s;
    }
    void set(T cx, T cy, T cz)
    {
        x = cx;
        y = cy;
        z = cz;
    }
    float Module()const
    {
        return std::sqrt(x * x + y * y + z * z);
    }
    
    Vector3 Normalized() const 
    {
        Vector3 v = *this;
        v.Normalize();
        return v;
    }
    
    /**
     *  叉乘
     */
    Vector3 Cross(const Vector3& v) const
    {
        return Vector3(y * v.z - z * v.y,
                       z * v.x - x * v.z,
                       x * v.y - y * v.x);
    }
    
    /**
     *	点乘
     */
    T Dot(const Vector3& v) const
    {
        return x * v.x + y * v.y + z * v.z;
    }
    
    Vector3 operator+(const Vector3& v) const
    {
        return Vector3(x + v.x, y + v.y,  z + v.z);
    }
    
    void operator+=(const Vector3& v)
    {
        x += v.x;
        y += v.y;
        z += v.z;
    }
    
    void operator-=(const Vector3& v)
    {
        x -= v.x;
        y -= v.y;
        z -= v.z;
    }
    
    void operator/=(T s)
    {
        x /= s;
        y /= s;
        z /= s;
    }
    
    Vector3 operator-(const Vector3& v) const
    {
        return Vector3(x - v.x, y - v.y,  z - v.z);
    }
    
    Vector3 operator-() const
    {
        return Vector3(-x, -y, -z);
    }
    Vector3 operator*(T s) const
    {
        return Vector3(x * s, y * s, z * s);
    }
    Vector3 operator/(T s) const
    {
        return Vector3(x / s, y / s, z / s);
    }
    bool operator==(const Vector3& v) const
    {
        return x == v.x && y == v.y && z == v.z;
    }
    
    /**
     *	返回本矢量和指定矢量之间的一个矢量
     *
     *	@param	t	比例系数
     *	@param	v	结束矢量
     *
     *	@return	新的矢量
     */
    Vector3 Lerp(float t, const Vector3& v) const
    {
        return Vector3(x * (1 - t) + v.x * t,
                       y * (1 - t) + v.y * t,
                       z * (1 - t) + v.z * t);
    }
    
    /**
     *	返回结构体中x变量的地址，相当于结构体的起始地址
     *	@return	T类型指针常量，注意不是const Vector3*
     */
    const T* Pointer() const
    {
        return &x;
    }
    
    /**
     *	将任意类型数据写入向量
     *
     *	@param	pData	将要写入的数据
     *
     *	@return	写入的数据的类型的指针，指向向量的下一个内存位置
     */
    template <typename P>
    P* Write(P* pData)
    {
        Vector3<T>* pVector = (Vector3<T>*) pData;
        *pVector++ = *this;
        return (P*) pVector;
    }
    
    T x;
    T y;
    T z;
};

template <typename T>
/**
 *	四维矢量
 */
struct Vector4 {
    Vector4() {}
    Vector4(T x, T y, T z, T w) : x(x), y(y), z(z), w(w) {}
    T Dot(const Vector4& v) const
    {
        return x * v.x + y * v.y + z * v.z + w * v.w;
    }
    
    /**
     *	返回本矢量和指定矢量之间的一个矢量
     *
     *	@param	t	比例系数
     *	@param	v	结束矢量
     *
     *	@return	新的矢量
     */
    Vector4 Lerp(float t, const Vector4& v) const
    {
        return Vector4(x * (1 - t) + v.x * t,
                       y * (1 - t) + v.y * t,
                       z * (1 - t) + v.z * t,
                       w * (1 - t) + v.w * t);
    }
    
    /**
     *	返回结构体中x变量的地址，相当于结构体的起始地址
     *	@return	T类型指针常量，注意不是const Vector3*
     */
    const T* Pointer() const
    {
        return &x;
    }
    T x;
    T y;
    T z;
    T w;
};

typedef Vector2<bool> bvec2;

typedef Vector2<int> ivec2;
typedef Vector3<int> ivec3;
typedef Vector4<int> ivec4;

typedef Vector2<float> vec2;
typedef Vector3<float> vec3;
typedef Vector4<float> vec4;
