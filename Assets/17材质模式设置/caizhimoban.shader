// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "caizhimoban"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("剔除模式", Float) = 1
		[Header(this is color mask)][Enum(UnityEngine.Rendering.ColorWriteMask)]_ColorMask("颜色遮罩", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_Float0("计算函数", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)]_Float1("模板测试相关", Float) = 0
		[Enum(UnityEngine.Rendering.BlendOp)]_Float2("混合计算", Float) = 0
		[Enum(on,0,off,1)]_Float3("深度写入", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend [_Src] [_Dst]
		BlendOp [_Float2]
		AlphaToMask On
		Cull [_CullMode]
		ColorMask [_ColorMask]
		ZWrite [_Float3]
		ZTest [_Float0]
		Offset 0 , 0
		Stencil
		{
			Ref 255
			Comp Always
			Pass [_Float1]
			Fail Keep
			ZFail Keep
		}
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Float2;
			uniform float _ColorMask;
			uniform float _CullMode;
			uniform float _Src;
			uniform float _Dst;
			uniform float _Float0;
			uniform float _Float3;
			uniform float _Float1;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				
				
				finalColor = tex2D( _TextureSample0, uv_TextureSample0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
0;6;2560;1373;1876;321.5;1;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-602,-42.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;fbf03e782a1811943a99f28c4fccac3e;fbf03e782a1811943a99f28c4fccac3e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1163,791.5;Inherit;False;Property;_Float2;混合计算;7;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1152,187.5;Inherit;False;Property;_ColorMask;颜色遮罩;2;2;[Header];[Enum];Create;False;1;this is color mask;0;1;UnityEngine.Rendering.ColorWriteMask;True;0;False;0;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1144,94.5;Inherit;False;Property;_CullMode;剔除模式;1;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1151,318.5;Inherit;False;Property;_Src;Src;3;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1158,419.5;Inherit;False;Property;_Dst;Dst;4;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1145,548.5;Inherit;False;Property;_Float0;计算函数;5;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1162,655.5;Inherit;False;Property;_Float1;模板测试相关;6;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1122,-21.5;Inherit;False;Property;_Float3;深度写入;8;1;[Enum];Create;False;0;2;on;0;off;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;111,-34;Float;False;True;-1;2;ASEMaterialInspector;100;1;caizhimoban;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;1;1;True;4;0;True;5;0;1;False;-1;0;False;-1;True;0;True;8;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;0;True;2;True;True;True;True;True;0;True;3;False;False;False;True;True;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;True;7;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;True;9;True;3;True;6;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=2D21AA19440E0E2C839AAC2BA93A042D97142366