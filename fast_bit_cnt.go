package main

import (
	"fmt"
)

type Uint128 struct {
	a uint64
	b uint64
}

var uint128_0 = Uint128{a: 0x0000000000000000, b: 0x0000000000000000}
var uint128_half_1 = Uint128{a: 0xffffffffffffffff, b: 0x0000000000000000}

//计算前导0个数
func (x *Uint128) nlz() (uint8) {
	if x.a == 0 {
		return 64 + nlz64(x.b)
	} else {
		return nlz64(x.a)
	}
}

func (x *Uint128) shiftl(n uint8) {
	x.a = (x.a << n) | (x.b >> (64 - n))
	x.b = x.b << n
}

func (x *Uint128) and(y *Uint128) {
	x.a = x.a & y.a
	x.b = x.b & y.b
}

func (x *Uint128) equal(y *Uint128) (bool) {
	if (x.a^y.a)|(x.b^y.b) == 0 {
		return true
	} else {
		return false
	}
}

func maxstr1(x *Uint128) (pos, len uint8) {
	tmp := Uint128{}
	for ; true; {
		// tmp = x & ( x<<1 )
		tmp = *x

		tmp.a = tmp.a<<1 | tmp.b>>63
		tmp.b = tmp.b << 1

		tmp.a = tmp.a & x.a
		tmp.b = tmp.b & x.b

		len++
		if (tmp.a^uint128_0.a)|(tmp.b^uint128_0.b) == 0 {
			pos = x.nlz()
			if pos == 128 {
				return 128, 0
			} else {
				return pos, len
			}
		}
		*x = tmp
	}
	return
}

//log2 128
func fmaxstr128(x *Uint128) (pos uint8, len uint8) {
	var y Uint128
	var tmp Uint128
	if x.equal(&uint128_0) {
		return 128, 0
	}

	//先查找最长连续为1串从哪里开始
	tmp = *x
	tmp.shiftl(1)
	tmp.and(x)
	y = tmp
	if y.equal(&uint128_0) {
		len = 1
		goto l1
	}

	tmp.shiftl(2)
	tmp.and(&y)
	*x = tmp
	if x.equal(&uint128_0) {
		len = 2
		*x = y
		goto l2
	}

	tmp = *x
	tmp.shiftl(4)
	tmp.and(x)
	y = tmp
	if y.equal(&uint128_0) {
		len = 4
		goto l4
	}

	tmp.shiftl(8)
	tmp.and(&y)
	*x = tmp
	if x.equal(&uint128_0) {
		len = 8
		*x = y
		goto l8
	}

	tmp = *x
	tmp.shiftl(16)
	tmp.and(x)
	y = tmp
	if y.equal(&uint128_0) {
		len = 16
		goto l16
	}

	tmp.shiftl(32)
	tmp.and(&y)
	*x = tmp
	if x.equal(&uint128_0) {
		len = 32
		*x = y
		goto l32
	}

	tmp = *x
	tmp.shiftl(64)
	tmp.and(x)
	y = tmp
	if y.equal(&uint128_0) {
		len = 64
		goto l64
	}

	if x.equal(&uint128_half_1) {
		return 0, 128
	}

	len = 64

	// 再计算这个串有多长
l64:
	tmp = *x
	tmp.shiftl(32)
	tmp.and(x)
	y = tmp
	if !y.equal(&uint128_0) {
		len += 32
		*x = y
	}

l32:
	tmp = *x
	tmp.shiftl(16)
	tmp.and(x)
	y = tmp
	if !y.equal(&uint128_0) {
		len += 16
		*x = y
	}

l16:
	tmp = *x
	tmp.shiftl(8)
	tmp.and(x)
	y = tmp
	if !y.equal(&uint128_0) {
		len += 8
		*x = y
	}

l8:
	tmp = *x
	tmp.shiftl(4)
	tmp.and(x)
	y = tmp
	if !y.equal(&uint128_0) {
		len += 4
		*x = y
	}
l4:
	tmp = *x
	tmp.shiftl(2)
	tmp.and(x)
	y = tmp
	if !y.equal(&uint128_0) {
		len += 2
		*x = y
	}

l2:
	tmp = *x
	tmp.shiftl(1)
	tmp.and(x)
	y = tmp
	if !y.equal(&uint128_0) {
		len += 1
		*x = y
	}

l1:
	pos = x.nlz()
	return
}

func nlz64(x uint64) (uint8) {
	var n uint8
	if x == 0 {
		return 64
	}
	n = 0
	if x <= 0x000000FFFFFFFFFF {
		n = n + 32
		x = x << 32
	}
	if x <= 0x0000FFFFFFFFFFFF {
		n = n + 16
		x = x << 16
	}
	if x <= 0x00FFFFFFFFFFFFFF {
		n = n + 8
		x = x << 8
	}
	if x <= 0x0FFFFFFFFFFFFFFF {
		n = n + 4
		x = x << 4
	}
	if x <= 0x3FFFFFFFFFFFFFFF {
		n = n + 2
		x = x << 2
	}
	if x <= 0x7FFFFFFFFFFFFFFF {
		n = n + 1
	}
	return n
}

//前导0 的个数
func leadZero(x byte) int {
	var n int
	if x == 0 {
		return 8
	}
	n = 0
	if x <= 0x0F {
		n = n + 4
		x = x << 4
	}
	if x <= 0x3F {
		n = n + 2
		x = x << 2
	}
	if x <= 0x7F {
		n = n + 1
	}
	return n
}

func leadZeroUint32(x uint32) int {
	var n int
	if x == 0 {
		return 32
	}
	n = 0
	if x <= 0x0000FFFF {
		n = n + 16
		x = x << 16
	}
	if x <= 0x00FFFFFF {
		n = n + 8
		x = x << 8
	}
	if x <= 0x0FFFFFFF {
		n = n + 4
		x = x << 4
	}
	if x <= 0x3FFFFFFF {
		n = n + 2
		x = x << 2
	}
	if x <= 0x7FFFFFFF {
		n = n + 1
	}
	return n
}

func leadOneUint32(x uint32) int {
	x = ^x
	var n int
	if x == 0 {
		return 32
	}
	n = 0
	if x <= 0x0000FFFF {
		n = n + 16
		x = x << 16
	}
	if x <= 0x00FFFFFF {
		n = n + 8
		x = x << 8
	}
	if x <= 0x0FFFFFFF {
		n = n + 4
		x = x << 4
	}
	if x <= 0x3FFFFFFF {
		n = n + 2
		x = x << 2
	}
	if x <= 0x7FFFFFFF {
		n = n + 1
	}
	return n
}

func leadZeroUint64(x uint64) int {
	var n int
	if x == 0 {
		return 64
	}
	n = 0
	if x <= 0x000000FFFFFFFFFF {
		n = n + 32
		x = x << 32
	}
	if x <= 0x0000FFFFFFFFFFFF {
		n = n + 16
		x = x << 16
	}
	if x <= 0x00FFFFFFFFFFFFFF {
		n = n + 8
		x = x << 8
	}
	if x <= 0x0FFFFFFFFFFFFFFF {
		n = n + 4
		x = x << 4
	}
	if x <= 0x3FFFFFFFFFFFFFFF {
		n = n + 2
		x = x << 2
	}
	if x <= 0x7FFFFFFFFFFFFFFF {
		n = n + 1
	}
	return n
}

func main() {
	pos, len := uint8(0), uint8(0)

	uint128_test := Uint128{a: 0x00, b: 0x00}

	uint128_test.a = 0x60f06ef7dfbe0f0f
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0x60f06ef7dfbe0f0f
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0x00
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0x00
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0xffffffffffffffff
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0xffffffffffffffff
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0xa0ffffffffffffff
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0xa0ffffffffffffff
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0xa0ffffffff0fffff
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0xa0ffffffff0fffff
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0xa0a1fffff00ffff1
	uint128_test.b = 0xfffffa000000010a
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0xa0a1fffff00ffff1
	uint128_test.b = 0xfffffa000000010a
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0xffffffffffffffff
	uint128_test.b = 0x0
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0xffffffffffffffff
	uint128_test.b = 0x0
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0x00
	uint128_test.b = 0x01
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0x00
	uint128_test.b = 0x01
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0xa000000000000000
	uint128_test.b = 0x01
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0xa000000000000000
	uint128_test.b = 0x01
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)

	uint128_test.a = 0xa000000000000001
	uint128_test.b = 0xa000000000000001
	pos, len = fmaxstr128(&uint128_test)
	fmt.Println("pos: ", pos, " ,len: ", len)
	uint128_test.a = 0xa000000000000001
	uint128_test.b = 0xa000000000000001
	pos, len = maxstr1(&uint128_test)
	fmt.Println("-pos: ", pos, " ,len: ", len)
}


