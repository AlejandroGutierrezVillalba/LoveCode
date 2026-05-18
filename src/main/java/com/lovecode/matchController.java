package com.lovecode;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/matches")
public class matchController {

    private final matchDAO matchDAO = new matchDAO();

    @GetMapping("/{idUsuario}")
    public List<String[]> obtenerMatches(@PathVariable int idUsuario) {
        return matchDAO.obtenerMatches(idUsuario);
    }

    @GetMapping(value = "/xml/{idUsuario}", produces = "application/xml")
    public String generarXML(@PathVariable int idUsuario) {
        return matchDAO.generarXML(idUsuario);
}
}