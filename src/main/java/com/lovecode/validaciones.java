package com.lovecode;

public class validaciones {

    public static String validarUsuario(usuario u) {

        // Nombre de Usuario
        if (u.getNombre() == null || u.getNombre().trim().isEmpty()) {
            return "El nombre no puede estar vacio";
        }
        if (u.getNombre().trim().length() < 3) {
            return "El nombre debe tener al menos 3 caracteres";
        }
        if (u.getNombre().trim().length() > 100) {
            return "El nombre no puede superar 100 caracteres";
        }
        if (!u.getNombre().matches("[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ ]+")) {
            return "El nombre solo puede contener letras y espacios";
        }

        // Email de Usuario
        if (u.getEmail() == null || u.getEmail().trim().isEmpty()) {
            return "El email no puede estar vacio";
        }
        if (u.getEmail().length() > 150) {
            return "El email no puede superar 150 caracteres";
        }
        if (!u.getEmail().matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "El formato del email no es valido";
        }

        // Password de Usuario
        if (u.getPassword() == null || u.getPassword().isEmpty()) {
            return "La contrasena no puede estar vacia";
        }
        if (u.getPassword().length() < 8) {
            return "La contrasena debe tener al menos 8 caracteres";
        }
        if (u.getPassword().length() > 255) {
            return "La contrasena no puede superar 255 caracteres";
        }
        if (!u.getPassword().matches(".*[A-Z].*")) {
            return "La contrasena debe contener al menos una mayuscula";
        }
        if (!u.getPassword().matches(".*[0-9].*")) {
            return "La contrasena debe contener al menos un numero";
        }

        // Ciudad (opcional)
        if (u.getCiudad() != null && !u.getCiudad().isEmpty()) {
            if (u.getCiudad().length() > 100) {
                return "La ciudad no puede superar 100 caracteres";
            }
            if (!u.getCiudad().matches("[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ ]+")) {
                return "La ciudad solo puede contener letras y espacios";
            }
        }

        return null;
    }
}