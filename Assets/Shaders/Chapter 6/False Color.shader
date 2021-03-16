Shader "Chapter 5/False Color"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR0;                
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //可视化法线方向
                // o.color = fixed4(v.normal*0.5+fixed3(0.5, 0.5, 0.5), 1.0);

                //可视化切线方向
                o.color = fixed4(v.tangent.xyz*0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                return i.color;
            }
            ENDCG
        }
    }
}
