  Shader "Toon/PGMToonShader" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_ToonLut ("Toon LUT", 2D) = "white" {}
		_MinColor ("Darkest Color", Color) = (0.2,0.2,0.2,1)
		_Color ("Color", Color) = (1,1,1,1)
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_RimPower ("Rim Power", Range(0, 10)) = 1		
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_OutlineThickness ("Outline Thickness", Range(0,1))  = 0.2
	}

	SubShader {
		//Outline pass
		Pass {
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"			

			half4 _OutlineColor;
			half _OutlineThickness;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex+v.normal*(_OutlineThickness/100));
				o.normal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return _OutlineColor;
			}
			ENDCG
		}
		
		//Toon surface shader
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
			#pragma surface surf ToonLight

			sampler2D _ToonLut;		
			half3 _MinColor;
			half3 _Color;
			half3 _RimColor;
			half _RimPower;

			half4 LightingToonLight (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
				half NdotL = dot (s.Normal, lightDir) * atten;
				float ndotv = saturate(dot(s.Normal, viewDir));

				float3 lut = max(_MinColor, tex2D(_ToonLut, float2(NdotL, 0)));
				float3 rim = _RimColor * pow(1 - ndotv, _RimPower) * NdotL;
				
				half4 c;
				c.rgb = s.Albedo * _Color * _LightColor0.rgb * lut;
				c.rgb += rim;
				c.a = s.Alpha;
				return c;
			}
  
			struct Input {
				float2 uv_MainTex;
			};
        
			sampler2D _MainTex;

			void surf (Input IN, inout SurfaceOutput o) {
				o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			}
		ENDCG
	}

	Fallback "Diffuse"
  }
