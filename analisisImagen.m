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

% Normalizar NIQE (menor es mejor)
max_niqe = max(calidades_niqe);
min_niqe = min(calidades_niqe);
niqe_normalizado = (calidades_niqe - min_niqe) / (max_niqe - min_niqe);

% Normalizar Tamaño del Archivo (menor es mejor)
max_tamano = max(tamanos_archivos);
min_tamano = min(tamanos_archivos);
tamano_normalizado = (tamanos_archivos - min_tamano) / (max_tamano - min_tamano);

% Definir pesos (ajustar estos según la importancia relativa)
peso_niqe = 0.7; % Mayor peso a la calidad
peso_tamano = 0.3; % Menor peso al tamaño

% Calcular puntuación compuesta
puntuacion_compuesta = peso_niqe * niqe_normalizado + peso_tamano * tamano_normalizado;

% Encontrar la imagen con la puntuación compuesta más baja
[~, indice_mejor] = min(puntuacion_compuesta);

% Detener el temporizador y mostrar el tiempo de ejecución
tiempo_ejecucion = toc;
disp(['Tiempo de ejecución: ' num2str(tiempo_ejecucion) ' segundos']);

% Mostrar la información de la mejor imagen
disp(['Mejor imagen según puntuación compuesta:']);
disp(['  Ruta: ' nombres_imagenes{indice_mejor}]);
disp(['  Tamaño del archivo: ' num2str(tamanos_archivos(indice_mejor)) ' KB']);
disp(['  Calidad (NIQE): ' num2str(calidades_niqe(indice_mejor))]);
disp(['  Puntuación Compuesta: ' num2str(puntuacion_compuesta(indice_mejor))]);

% Guardar la información en un archivo de texto
nombre_archivo = 'resultados.txt';
fid = fopen(nombre_archivo, 'w');

fprintf(fid, 'Información sobre el uso de memoria:\n');
fprintf(fid, 'Memoria total: %.4f MB\n', mem_info.MemAvailableAllArrays / (1024^2));
fprintf(fid, 'Memoria utilizada: %.4f MB\n', mem_info.MemUsedMATLAB / (1024^2));
fprintf(fid, 'Tiempo de ejecución: %.4f segundos\n\n', tiempo_ejecucion);

fprintf(fid, 'Resultados de Análisis de Imágenes:\n');
for i = 1:numel(nombres_imagenes)
    fprintf(fid, 'Imagen %d: %s\n', i, nombres_imagenes{i});
    fprintf(fid, '  Tamaño del archivo: %.4f KB\n', tamanos_archivos(i));
    fprintf(fid, '  Calidad (NIQE): %.4f\n', calidades_niqe(i));
    fprintf(fid, '  Puntuación Compuesta: %.4f\n\n', puntuacion_compuesta(i));
end

fprintf(fid, 'Mejor imagen según puntuación compuesta:\n');
fprintf(fid, '  Ruta: %s\n', nombres_imagenes{indice_mejor});
fprintf(fid, '  Tamaño del archivo: %.4f KB\n', tamanos_archivos(indice_mejor));
fprintf(fid, '  Calidad (NIQE): %.4f\n', calidades_niqe(indice_mejor));
fprintf(fid, '  Puntuación Compuesta: %.4f\n', puntuacion_compuesta(indice_mejor));

fclose(fid);
