using Godot;
using System;
using System.IO.Ports;
using System.Threading;

public partial class serial : Node2D {
	SerialPort port;
	CharacterBody2D tractor;
	TileMap ground_tiles;
	float gdelta;
	float rotinc;
	float moveinc;
	float shootinc;
	bool start_btn_state = false;
	float timer = 0.1F;
	const float timer_max = 0.1F; // 10 times per second
	byte[] msg = new byte[] { 0x0 };
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready() {
		tractor = GetNode<CharacterBody2D>("../Tractor");
		ground_tiles = (TileMap)tractor.GetParent();
		
		port = new SerialPort("/dev/cu.usbserial-A50285BI", 115200);
		port.Open();
		
		Thread recv_thread = new Thread(new ThreadStart(receiveData));
		recv_thread.Start();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta) {
		gdelta = (float)delta;
		tractor.Rotation += rotinc;
		
		tractor.Velocity = tractor.Transform.X * moveinc * 400;
		tractor.MoveAndSlide();
		
		if (shootinc == 1) {
			tractor.Call("shoot");
			shootinc = 0;
		}
		
		timer -= gdelta;
		if (timer <= 0) { // run only 10 times per second
			
			if (msg[0] == 10) msg[0] = 0;
			
			uint time_left = (uint)ground_tiles.Call("get_time_left");
			uint carrots = (uint)tractor.Call("get_carrots");
			
			msg[0] = (byte)((time_left << 3) | carrots);
			
			port.Write(msg, 0, 1);
			
			timer = timer_max; // restore timer
			msg[0]++;
		}
	}
	
	void receiveData() {
		while (true) {
			int recv = port.ReadByte();
			int data = recv;
			
			// gestionar el disparar en el byte recibido
			if ((data & 0b1000) == 0b1000) {
				shootinc = 1;
			} else if ((data & 0b10) == 0b0) {
				shootinc = 0;
			}
			
			if (!start_btn_state) continue;
			
			// gestionar las rotaciones en el byte recibido
			if ((data & 0b10) == 0b10) {
					rotinc = 1 * (float)1.0 * (float)gdelta;
			} else if ((data & 0b1) == 0b1) {
					rotinc = -1 * (float)1.0 * (float)gdelta;
			} else if ((data & 0b00000011) == 0) {
					rotinc = 0;
			}
			
			// gestionar el avanzar en el byte recibido
			if ((data & 0b100) == 0b100) {
				moveinc = 1;
			} else if ((data & 0b10) == 0b0) {
				moveinc = 0;
			}
		}
	}
	
	private void _on_start_button_pressed() {
		start_btn_state = true;
	}
}
