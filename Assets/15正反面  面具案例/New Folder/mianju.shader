// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cz_wang/mianju"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Fresnel("Fresnel", Vector) = (0,1,5,0)
		[HDR]_FresnelColor("FresnelColor", Color) = (1,1,1,0)
		_BackTex("BackTex", 2D) = "white" {}
		_BackUV_Speed("BackUV_Speed", Vector) = (1,1,0,0)
		_AddTex("AddTex", 2D) = "white" {}
		_AddUV_Speed("AddUV_Speed", Vector) = (1,1,0,0)
		[HDR]_AddColor("AddColor", Color) = (1,1,1,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseUV_Speed("NoiseUV_Speed", Vector) = (1,1,0,0)
		_NoiseIntensity("NoiseIntensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float3 _Fresnel;
			uniform float4 _FresnelColor;
			uniform sampler2D _BackTex;
			uniform float4 _BackUV_Speed;
			uniform sampler2D _AddTex;
			uniform float4 _AddUV_Speed;
			uniform sampler2D _NoiseTex;
			uniform float4 _NoiseUV_Speed;
			uniform float _NoiseIntensity;
			uniform float4 _AddColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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
			
			fixed4 frag (v2f i , half ase_vface : VFACE) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float fresnelNdotV4 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode4 = ( _Fresnel.x + _Fresnel.y * pow( 1.0 - fresnelNdotV4, _Fresnel.z ) );
				float2 appendResult30 = (float2(_BackUV_Speed.z , _BackUV_Speed.w));
				float4 screenPos = i.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_output_10_0 = (ase_screenPosNorm).xy;
				float2 appendResult31 = (float2(_BackUV_Speed.x , _BackUV_Speed.y));
				float2 panner33 = ( 1.0 * _Time.y * appendResult30 + ( temp_output_10_0 * appendResult31 ));
				float2 appendResult19 = (float2(_AddUV_Speed.z , _AddUV_Speed.w));
				float2 appendResult18 = (float2(_AddUV_Speed.x , _AddUV_Speed.y));
				float2 panner21 = ( 1.0 * _Time.y * appendResult19 + ( temp_output_10_0 * appendResult18 ));
				float2 appendResult14 = (float2(_NoiseUV_Speed.z , _NoiseUV_Speed.w));
				float2 appendResult13 = (float2(_NoiseUV_Speed.x , _NoiseUV_Speed.y));
				float2 panner15 = ( 1.0 * _Time.y * appendResult14 + ( temp_output_10_0 * appendResult13 ));
				float2 temp_cast_0 = (tex2D( _NoiseTex, panner15 ).r).xx;
				float2 lerpResult23 = lerp( panner21 , temp_cast_0 , _NoiseIntensity);
				float4 switchResult8 = (((ase_vface>0)?(( tex2D( _MainTex, uv_MainTex ) + ( saturate( fresnelNode4 ) * _FresnelColor ) )):(( tex2D( _BackTex, panner33 ) + ( tex2D( _AddTex, lerpResult23 ).r * _AddColor ) ))));
				
				
				finalColor = switchResult8;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
418;72.66667;1751;1005;887.6011;917.8052;2.2;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;9;-1859.956,516.2252;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;12;-2203.99,1209.199;Inherit;False;Property;_NoiseUV_Speed;NoiseUV_Speed;9;0;Create;True;0;0;0;False;0;False;1,1,0,0;4,1,0.1,0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;10;-1568.226,513.152;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1863.19,1212.4;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;20;-1175.19,844.3994;Inherit;False;Property;_AddUV_Speed;AddUV_Speed;6;0;Create;True;0;0;0;False;0;False;1,1,0,0;4,0.5,0,0.2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1333.591,1162.799;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-915.9902,852.3994;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1739.991,1389.999;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;32;-780.579,564.2941;Inherit;False;Property;_BackUV_Speed;BackUV_Speed;4;0;Create;True;0;0;0;False;0;False;1,1,0,0;3,3,0,0.2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;19;-890.3903,1041.199;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-736.7903,805.9992;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;15;-1050.39,1226.8;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;16;-762.3903,1202.799;Inherit;True;Property;_NoiseTex;NoiseTex;8;0;Create;True;0;0;0;False;0;False;-1;None;72105e201951b3e4880cc3dd97797249;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-673.4509,1492.678;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;10;0;Create;True;0;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-470.2509,894.2776;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;-417.7794,527.4941;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;3;-1457.965,-282.7288;Inherit;False;Property;_Fresnel;Fresnel;1;0;Create;True;0;0;0;False;0;False;0,1,5;0,1,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;30;-376.1795,655.4937;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;4;-1165.465,-290.5288;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-228.9795,426.6941;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;23;-238.2508,1131.078;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;7;-966.565,-100.7288;Inherit;False;Property;_FresnelColor;FresnelColor;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,2.545874,2.639016,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;33;43.95996,444.5723;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;22;-14.25088,1047.878;Inherit;True;Property;_AddTex;AddTex;5;0;Create;True;0;0;0;False;0;False;-1;None;8bdbef44c4848774986e23b1f24bce72;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;5;-878.1658,-285.3288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;159.1536,1330.667;Inherit;False;Property;_AddColor;AddColor;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0.4634897,0.5407379,1.409781,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-675.3646,-219.0288;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-694.8643,-651.9289;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;b4a955bd8224aca4385d11baac24d3eb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;457.4535,1083.667;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;34;355.3546,432.3921;Inherit;True;Property;_BackTex;BackTex;3;0;Create;True;0;0;0;False;0;False;-1;None;7dad2b8decbed5643a2502cc5d3a6cad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;28;789.9539,629.5668;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-235.9645,-238.5289;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;8;1276.635,29.77105;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1826.8,-7.999931;Float;False;True;-1;2;ASEMaterialInspector;100;1;Cz_wang/mianju;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;10;0;9;0
WireConnection;13;0;12;1
WireConnection;13;1;12;2
WireConnection;11;0;10;0
WireConnection;11;1;13;0
WireConnection;18;0;20;1
WireConnection;18;1;20;2
WireConnection;14;0;12;3
WireConnection;14;1;12;4
WireConnection;19;0;20;3
WireConnection;19;1;20;4
WireConnection;17;0;10;0
WireConnection;17;1;18;0
WireConnection;15;0;11;0
WireConnection;15;2;14;0
WireConnection;16;1;15;0
WireConnection;21;0;17;0
WireConnection;21;2;19;0
WireConnection;31;0;32;1
WireConnection;31;1;32;2
WireConnection;30;0;32;3
WireConnection;30;1;32;4
WireConnection;4;1;3;1
WireConnection;4;2;3;2
WireConnection;4;3;3;3
WireConnection;29;0;10;0
WireConnection;29;1;31;0
WireConnection;23;0;21;0
WireConnection;23;1;16;1
WireConnection;23;2;24;0
WireConnection;33;0;29;0
WireConnection;33;2;30;0
WireConnection;22;1;23;0
WireConnection;5;0;4;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;25;0;22;1
WireConnection;25;1;27;0
WireConnection;34;1;33;0
WireConnection;28;0;34;0
WireConnection;28;1;25;0
WireConnection;2;0;1;0
WireConnection;2;1;6;0
WireConnection;8;0;2;0
WireConnection;8;1;28;0
WireConnection;0;0;8;0
ASEEND*/
//CHKSM=0786ADF8781832AFD8F15FA1168B02B7333C517A