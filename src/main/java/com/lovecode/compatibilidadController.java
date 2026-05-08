package com.lovecode;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/compatibilidad")
public class compatibilidadController {

    private final compatibilidadDAO compatibilidadDAO = new compatibilidadDAO();

    @GetMapping("/{idUsuario1}/{idUsuario2}")
    public String obtenerCompatibilidad(
            @PathVariable int idUsuario1,
            @PathVariable int idUsuario2) {
        return compatibilidadDAO.obtenerCompatibilidad(idUsuario1, idUsuario2);
    }
}