texture gTexture;

technique Render
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}