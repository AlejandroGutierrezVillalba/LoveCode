package com.lovecode;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/matches")
public class matchController {

    private final matchDAO matchDAO = new matchDAO();

    @GetMapping("/{idUsuario}")
    public List<String[]> obtenerMatches(@PathVariable int idUsuario) {
        return matchDAO.obtenerMatches(idUsuario);
    }

    @GetMapping("/xml/{idUsuario}")
    public String generarXML(@PathVariable int idUsuario) {
        return matchDAO.generarXML(idUsuario);
    }
}