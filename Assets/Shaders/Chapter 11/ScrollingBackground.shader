Shader "Chapter 11/ScrollingBackground"
{
    Properties
    {
        _MainTex ("Far Layer(RGB)", 2D) = "white" {}
        _DetailTex ("Near Layer(RGB)", 2D) = "white" {}
        _ScrollX ("Far layer Scroll Speed", Float) = 1.0
        _Scroll2X ("Near layer Scroll Speed", Float) = 1.0
        _Multiplier ("Layer Multiplier", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DetailTex;
            float4 _DetailTex_ST;
            float _ScrollX;
            float _Scroll2X;
            float _Multiplier;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex)+frac(float2(_ScrollX, 0.0) * _Time.y);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _DetailTex)+frac(float2(_Scroll2X, 0.0) * _Time.y);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 farLayer = tex2D(_MainTex, i.uv.xy);
                fixed4 nearLayer = tex2D(_DetailTex, i.uv.zw);

                fixed4 c = lerp(farLayer, nearLayer, nearLayer.a);
                c.rgb *= _Multiplier;

                return c;
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}
