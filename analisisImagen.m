% Obtener información sobre el uso de memoria
mem_info = memory;

% Iniciar el temporizador
tic;

% Lista de nombres de imágenes (asegúrate de que estén en el mismo directorio
% que tu script o proporciona rutas completas)
nombres_imagenes = {'foto1.jpg', 'foto2.jpeg', 'foto3.jpg', 'foto4.jpg'};

% Inicializar matrices para almacenar datos
tamanos_archivos = zeros(1, numel(nombres_imagenes));
calidades_niqe = zeros(1, numel(nombres_imagenes));

% Procesar cada imagen
for i = 1:numel(nombres_imagenes)
    % Construir la ruta completa (ajusta esto según la ubicación de tus archivos)
    ruta_imagen = nombres_imagenes{i};
    
    try
        % Obtener información del archivo de la imagen
        info = imfinfo(ruta_imagen);
        tamano_archivo = info.FileSize / 1024; % Convertir a KB
        tamanos_archivos(i) = tamano_archivo;

        % Calidad de la imagen utilizando la función NIQE
        calidad_niqe = niqe(imread(ruta_imagen));
        calidades_niqe(i) = calidad_niqe;

        % Mostrar información de la imagen actual
        disp(['Imagen ' num2str(i) ':']);
        disp(['  Ruta: ' ruta_imagen]);
        disp(['  Tamaño del archivo: ' num2str(tamano_archivo) ' KB']);
        disp(['  Calidad (NIQE): ' num2str(calidad_niqe)]);
    catch
        % Manejar cualquier error que pueda ocurrir al procesar la imagen
        disp(['Error al procesar la imagen ' num2str(i) ': ' nombres_imagenes{i}]);
    end
end

% Ajuste de curvas (puedes elegir un polinomio de grado adecuado)
grado_pol = 2;
coeficientes_niqe = polyfit(tamanos_archivos, calidades_niqe, grado_pol);

% Crear un conjunto de datos para el ajuste
tamanos_pred = linspace(min(tamanos_archivos), max(tamanos_archivos), 100);
calidades_pred_niqe = polyval(coeficientes_niqe, tamanos_pred);

% Graficar los datos y el ajuste
figure;
scatter(tamanos_archivos, calidades_niqe, 'o');
hold on;
plot(tamanos_pred, calidades_pred_niqe, '-')
hold off;
xlabel('Tamaño del archivo (KB)');
ylabel('Calidad de la imagen (NIQE)');
title('Relación entre Tamaño y Calidad de Imágenes (NIQE)');
legend('Datos', 'Ajuste de Curvas', 'Location', 'best');

% Mostrar los coeficientes del polinomio
disp('Coeficientes del polinomio de ajuste (NIQE):');
disp(coeficientes_niqe);

% Mostrar información sobre el uso de memoria
disp('Información sobre el uso de memoria:');
disp(['Memoria total: ' num2str(mem_info.MemAvailableAllArrays / (1024^2)) ' MB']);
disp(['Memoria utilizada: ' num2str(mem_info.MemUsedMATLAB / (1024^2)) ' MB']);

% Calcular la métrica de la relación calidad/tamaño
metrica_relacion = calidades_niqe .* tamanos_archivos;

% Encontrar la imagen con la mejor métrica
[mejor_metrica, indice_mejor] = max(metrica_relacion);

% Detener el temporizador y mostrar el tiempo de ejecución
tiempo_ejecucion = toc;
disp(['Tiempo de ejecución: ' num2str(tiempo_ejecucion) ' segundos']);

% Mostrar la información de la mejor imagen
disp(['Mejor imagen:']);
disp(['  Ruta: ' nombres_imagenes{indice_mejor}]);
disp(['  Tamaño del archivo: ' num2str(tamanos_archivos(indice_mejor)) ' KB']);
disp(['  Calidad (NIQE): ' num2str(calidades_niqe(indice_mejor))]);
disp(['  Métrica de Relación: ' num2str(mejor_metrica)]);

% Guardar la información en un archivo de texto
nombre_archivo = 'resultados.txt';
fid = fopen(nombre_archivo, 'w');
fprintf(fid, 'Información sobre el uso de memoria:\n');
fprintf(fid, 'Memoria total: %.4f MB\n', mem_info.MemAvailableAllArrays / (1024^2));
fprintf(fid, 'Memoria utilizada: %.4f MB\n', mem_info.MemUsedMATLAB / (1024^2));
fprintf(fid, 'Tiempo de ejecución: %.4f segundos\n\n', tiempo_ejecucion);

fprintf(fid, 'Mejor imagen:\n');
fprintf(fid, '  Ruta: %s\n', nombres_imagenes{indice_mejor});
fprintf(fid, '  Tamaño del archivo: %.4f KB\n', tamanos_archivos(indice_mejor));
fprintf(fid, '  Calidad (NIQE): %.4f\n', calidades_niqe(indice_mejor));

fclose(fid);
