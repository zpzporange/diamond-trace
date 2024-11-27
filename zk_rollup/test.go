package zk_rollup

type Circuit interface {
	// Define declares the circuit's Constraints
	Define(api frontend.API) error
}

type MyCircuit struct {
	C myComponent
	Y frontend.Variable `gnark:",public"`
}

type myComponent struct {
	X frontend.Variable
}

func (circuit *MyCircuit) Define(api frontend.API) error {
	// ... see Circuit API section
}
