package com.lovecode;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class validacionesTest {

    //Email válido
    @Test
    public void testEmailValido() {
        usuario u = new usuario();
        u.setNombre("Ada Lovelace");
        u.setEmail("ada@lovecode.dev");
        u.setPassword("Password1");

        String resultado = validaciones.validarUsuario(u);
        assertNull(resultado, "El email válido no debería dar error");
    }

    // Email no válido
    @Test
    public void testEmailInvalido() {
        usuario u = new usuario();
        u.setNombre("Ada Lovelace");
        u.setEmail("adaSINdominio");
        u.setPassword("Password1");

        String resultado = validaciones.validarUsuario(u);
        assertNotNull(resultado, "El email sin dominio debería dar error");
    }

    // Contraseña sin mayúsculas
    @Test
    public void testPasswordSinMayuscula() {
        usuario u = new usuario();
        u.setNombre("Ada Lovelace");
        u.setEmail("ada@lovecode.dev");
        u.setPassword("password1");

        String resultado = validaciones.validarUsuario(u);
        assertNotNull(resultado, "La contraseña sin mayúscula debería dar error");
        assertEquals("La contrasena debe contener al menos una mayuscula", resultado);
    }
}