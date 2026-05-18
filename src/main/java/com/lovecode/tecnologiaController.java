package com.lovecode;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/tecnologias")
public class tecnologiaController {

    private final tecnologiaDAO tecnologiaDAO = new tecnologiaDAO();

    @GetMapping
    public List<String[]> obtenerTodas() {
        return tecnologiaDAO.obtenerTodas();
    }

    @PostMapping("/usuario/{idUsuario}")
    public String guardarTecnologia(
            @PathVariable int idUsuario,
            @RequestBody Map<String, String> body) {

        int idTecnologia = Integer.parseInt(body.get("idTecnologia"));
        String nivel = body.get("nivel");

        boolean resultado = tecnologiaDAO.guardarTecnologiasUsuario(idUsuario, idTecnologia, nivel);
        return resultado ? "Tecnologia guardada correctamente" : "Error al guardar tecnologia";
    }

    @GetMapping("/usuario/{idUsuario}")
    public List<String[]> obtenerPorUsuario(@PathVariable int idUsuario) {
        return tecnologiaDAO.obtenerPorUsuario(idUsuario);
}
}