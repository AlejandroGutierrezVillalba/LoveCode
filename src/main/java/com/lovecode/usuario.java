package com.lovecode;

public class usuario {
    private int idUsuario;
    private String nombre;
    private String email;
    private String password;
    private String descripcion;
    private String ciudad;
    private String fechaRegistro;
    private int activo;

    public usuario() {}

    public usuario(int idUsuario, String nombre, String email, String descripcion, String ciudad, String fechaRegistro) {
        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.email = email;
        this.descripcion = descripcion;
        this.ciudad = ciudad;
        this.fechaRegistro = fechaRegistro;
    }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getCiudad() { return ciudad; }
    public void setCiudad(String ciudad) { this.ciudad = ciudad; }

    public String getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(String fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public int getActivo() { return activo; }
    public void setActivo(int activo) { this.activo = activo; }
}