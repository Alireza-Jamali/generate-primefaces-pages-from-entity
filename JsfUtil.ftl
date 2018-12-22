package serp3.mbean.util;

import java.awt.Desktop;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.List;
import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.model.SelectItem;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.util.stream.Collectors;

public class JsfUtil {

    public static SelectItem[] getSelectItems(List<?> entities, boolean selectOne) {
        int size = selectOne ? entities.size() + 1 : entities.size();
        SelectItem[] items = new SelectItem[size];
        int i = 0;
        if (selectOne) {
            items[0] = new SelectItem("", "---");
            i++;
        }
        for (Object x : entities) {
            items[i++] = new SelectItem(x, x.toString());
        }
        return items;
    }

    public static boolean isValidationFailed() {
        return FacesContext.getCurrentInstance().isValidationFailed();
    }

    public static void addErrorMessage(Exception ex, String defaultMsg) {
        String msg = ex.getLocalizedMessage();
        if (msg != null && msg.length() > 0) {
            addErrorMessage(msg);
        } else {
            addErrorMessage(defaultMsg);
        }
    }

    public static void addErrorMessages(List<String> messages) {
        for (String message : messages) {
            addErrorMessage(message);
        }
    }

    public static void addErrorMessage(String msg) {
        FacesMessage facesMsg = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg, msg);
        FacesContext.getCurrentInstance().addMessage(null, facesMsg);
    }

    public static void addSuccessMessage(String msg) {
        FacesMessage facesMsg = new FacesMessage(FacesMessage.SEVERITY_INFO, msg, msg);
        FacesContext.getCurrentInstance().addMessage("successInfo", facesMsg);
    }

    public static String getRequestParameter(String key) {
        return FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get(key);
    }

    public static Object getObjectFromRequestParameter(String requestParameterName, Converter converter, UIComponent component) {
        String theId = JsfUtil.getRequestParameter(requestParameterName);
        return converter.getAsObject(FacesContext.getCurrentInstance(), component, theId);
    }

    public static enum PersistAction {
        CREATE,
        DELETE,
        UPDATE
    }
    static Path convertersDir;
    static Path controllersDir;
    static Path facadeDir;
    static Path faceletDir;

    public static void main(String[] args) throws IOException {

        try {
            if (Files.exists(Paths.get("out"), LinkOption.NOFOLLOW_LINKS)) {
                Files.list(Paths.get("out")).forEach(dir -> {
                    if (Files.isDirectory(dir, LinkOption.NOFOLLOW_LINKS)) {
                        try {
                            Files.list(dir).forEach(del -> {
                                try {
                                    Files.deleteIfExists(del);
                                } catch (IOException ex) {
                                }
                            });
                        } catch (IOException ex) {

                        }
                    }
                });
            }
        } catch (IOException ex) {
        }
        Files.list(Paths.get("web")).forEach(p -> {
            if (!p.endsWith("index.xhtml")
                    && !p.endsWith("template.xhtml")
                    && !p.endsWith("WEB-INF")
                    && !p.endsWith("resources")) {
                Path file = Paths.get(p.toString(), "list.xhtml");
                try {
                    Files.move(file, Paths.get("web", p.getFileName().toString().substring(0, 1).toUpperCase() + p.getFileName().toString().substring(1) + ".xhtml"));
                    Files.deleteIfExists(p);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        });

//        -----------------------------------------------------------------------------------------
        try {
            convertersDir = Files.createDirectories(Paths.get("out", "converter"));
        } catch (Exception ex) {
            convertersDir = Paths.get("out", "converter");
        }
        try {
            controllersDir = Files.createDirectory(Paths.get("out", "mbean"));
        } catch (Exception ex) {
            controllersDir = Paths.get("out", "mbean");
        }
        try {
            facadeDir = Files.createDirectory(Paths.get("out", "ejb"));
        } catch (Exception ex) {
            facadeDir = Paths.get("out", "ejb");
        }
        try {
            faceletDir = Files.createDirectory(Paths.get("out", "web"));
        } catch (Exception ex) {
            faceletDir = Paths.get("out", "web");
        }

        Files.list(Paths.get("src\\java\\serp3\\mbean")).forEach(controllerFile -> {
            try {
                BufferedReader br = new BufferedReader(new FileReader(controllerFile.toFile()));
                String controller = "";
                String converter = "";
                boolean sw = false;
                while (br.ready()) {
                    String line = br.readLine();
                    if (line.contains("//---")) {
                        sw = true;
                        continue;
                    }
                    if (!sw) {
                        controller += line + "\n";
                    } else {
                        converter += line + "\n";
                    }
                }
                br.close();
                Path converterFile = Paths.get(convertersDir.toString(), controllerFile.getFileName().toString().replaceAll("Controller", "Converter"));
                Files.write(Paths.get(controllersDir.toString(), controllerFile.getFileName().toString()), controller.getBytes(StandardCharsets.UTF_8), StandardOpenOption.CREATE);
                Files.delete(controllerFile);
                Files.write(converterFile, converter.getBytes(StandardCharsets.UTF_8), StandardOpenOption.CREATE);
            } catch (Exception ex) {

            }

        });
        Files.delete(Paths.get("src\\java\\serp3\\ejb\\AbstractFacade.java"));
        Files.delete(Paths.get("src\\java\\Bundle.properties"));
        Files.list(Paths.get("src\\java\\serp3\\ejb")).forEach(bean -> {
            try {
                Files.move(bean, Paths.get(facadeDir.toString(), bean.getFileName().toString()), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException ex) {
            }
        });
        Files.list(Paths.get("web")).filter(file -> file.getFileName().toString().endsWith(".xhtml")).collect(Collectors.toList()).forEach(facelet -> {
            try {
                Files.move(facelet, Paths.get(faceletDir.toString(), facelet.getFileName().toString()), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException ex) {
            }
        });
//        -----------------------------------------------------------------------------------

		Desktop.getDesktop().open(new File("out"));
    }
}
