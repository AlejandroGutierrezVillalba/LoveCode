<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
    <meta charset="UTF-8"/>
    <title>LoveCode - Ficha de Compatibilidad</title>
    <style>
        body {
            font-family: 'Georgia', serif;
            background-color: #D9D0BE;
            color: #3D2B1F;
            padding: 40px;
        }
        h1 {
            font-size: 2rem;
            color: #E8634A;
            margin-bottom: 30px;
        }
        .match-card {
            background: #F5F0E4;
            border: 1px solid #CEC5B5;
            border-radius: 12px;
            padding: 28px;
            margin-bottom: 20px;
            max-width: 500px;
        }
        .match-usuarios {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .match-fecha {
            font-size: 0.85rem;
            color: #7A6558;
            margin-bottom: 16px;
        }
        .tech-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .tech-tag {
            background: rgba(232,99,74,0.12);
            color: #C94F38;
            border: 1px solid rgba(232,99,74,0.3);
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 0.82rem;
        }
    </style>
</head>
<body>
    <h1>Fichas de Compatibilidad</h1>
    <xsl:for-each select="matches/match">
        <div class="match-card">
            <p class="match-usuarios">
                <xsl:value-of select="usuario1"/> ♥ <xsl:value-of select="usuario2"/>
            </p>
            <p class="match-fecha">Match el <xsl:value-of select="fecha"/></p>
            <div class="tech-list">
                <xsl:for-each select="tecnologias_comunes/tecnologia">
                    <span class="tech-tag"><xsl:value-of select="."/></span>
                </xsl:for-each>
            </div>
        </div>
    </xsl:for-each>
</body>
</html>
</xsl:template>

</xsl:stylesheet>