// N64 'Bare Metal' 16BPP 320x240 Cycle1 Fill Line RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "Cycle1FillLine16BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M1A_0_2 // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FF0000FF // Set Blend Color: R 255,G 0,B 0,A 255 (Red)
  // Line (Dir=1)
  //
  //          . v[1]:XL,XH(X:75.0) YM,YH(Y:50.0)
  //         / DxHDy
  //  DxLDy /
  //       . v[0]:(X:25.0) YL(Y:100.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 100.0,YM 50.0,YH 50.0, XL 76.0,DxLDy -1.0, XH 75.0,DxHDy -1.0
     Fill_Triangle 1,0,0, 400,200,200, 76,0,-1,0, 75,0,-1,0, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $00FF00FF // Set Blend Color: R 0,G 255,B 0,A 255 (Green)
  // Line (Dir=1)
  //
  //     . v[1]:XL,XH(X:100.0) YM,YH(Y:50.0)
  //      \ DxHDy
  // DxLDy \
  //        . v[0]:(X:150.0) YL(Y:100.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 100.0,YM 50.0,YH 50.0, XL 101.0,DxLDy 1.0, XH 100.0,DxHDy 1.0
     Fill_Triangle 1,0,0, 400,200,200, 101,0,1,0, 100,0,1,0, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $0000FFFF // Set Blend Color: R 0,G 0,B 255,A 255 (Blue)
  // Line (Dir=1)
  //
  //       . v[1]:XL,XH(X:175.0) YM,YH(Y:50.0)
  //       | DxHDy
  // DxLDy |
  //       . v[0]:(X:175.0) YL(Y:100.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 100.0,YM 50.0,YH 50.0, XL 176.0,DxLDy 0.0, XH 175.0,DxHDy 0.0
     Fill_Triangle 1,0,0, 400,200,200, 176,0,0,0, 175,0,0,0, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FFFFFFFF // Set Blend Color: R 255,G 255,B 255,A 255 (White)
  // Line (Dir=1)
  //
  //  DxHDy
  //  .___. v[1]:XH(X:250.0) YL(Y:100.0), v[0]:XL(X:300.0) YM,YH(Y:100.0)
  //  DxLDy
  //
  // Output: Dir 1,Level 0,Tile 0, YL 101.0,YM 100.0,YH 100.0, XL 300.0,DxLDy 0.0, XH 250.0,DxHDy 0.0
     Fill_Triangle 1,0,0, 404,400,400, 300,0,0,0, 250,0,0,0, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FF0000FF // Set Blend Color: R 255,G 0,B 0,A 255 (Red)
  // Right Major Triangle (Dir=1)
  //
  //     . v[1]:XL,XH(X:25.0) YM,YH(Y:150.0)
  //      \ DxHDy
  // DxLDy \
  //        . v[0]:(X:75.0) YL(Y:175.0)           
  //
  // Output: Dir 1,Level 0,Tile 0, YL 175.0,YM 150.0,YH 150.0, XL 27.0,DxLDy 2.0, XH 25.0,DxHDy 2.0
     Fill_Triangle 1,0,0, 700,600,600, 27,0,2,0, 25,0,2,0, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $00FF00FF // Set Blend Color: R 0,G 255,B 0,A 255 (Green)
  // Line (Dir=1)
  //
  //         . v[1]:XL,XH(X:150.0) YM,YH(Y:150.0)
  //        /
  // DxLDy / DxHDy
  //      /
  //     . v[0]:(X:125.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 150.0,YH 150.0, XL 151.0,DxLDy -0.5, XH 150.0,DxHDy -0.5
     Fill_Triangle 1,0,0, 800,600,600, 151,0,-1,32768, 150,0,-1,32768, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $0000FFFF // Set Blend Color: R 0,G 0,B 255,A 255 (Blue)
  // Line (Dir=1)
  //
  //         . v[1]:XH,XM(X:225.0) YH(Y:150.0)
  //        / DxHDy
  // DxLDy /
  //      . v[0]:XL(X:175.0) YM(Y:175.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 175.0,YM 150.0,YH 150.0, XL 227.0,DxLDy -2.0, XH 225.0,DxHDy -2.0
     Fill_Triangle 1,0,0, 700,600,600, 227,0,-2,0, 225,0,-2,0, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FFFFFFFF // Set Blend Color: R 255,G 255,B 255,A 255 (White)
  // Line (Dir=1)
  //
  //     . v[1]:XH,XM(X:275.0) YH(Y:150.0)
  //      \
  // DxLDy \ DxHDy
  //        \  
  //         . v[0]:(X:300.0) YL(Y:200.0)
  //
  // Output: Dir 1,Level 0,Tile 0, YL 200.0,YM 150.0,YH 150.0, XL 276.0,DxLDy -0.5, XH 275.0,DxHDy -0.5
     Fill_Triangle 1,0,0, 800,600,600, 276,0,0,32768, 275,0,0,32768, 0,0,0,0 // Generated By N64LineCalc.py

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd: