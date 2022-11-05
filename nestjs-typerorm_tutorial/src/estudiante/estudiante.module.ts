import { EstudianteService } from './estudiante.service';
import { EstudianteController } from './estudiante.controller';
import { Module } from '@nestjs/common';
import { EstudiantesEntity } from 'src/estudiante/estudiantes.entity';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
    imports: [TypeOrmModule.forFeature([EstudiantesEntity])],
    controllers: [
        EstudianteController,],
    providers: [
        EstudianteService,],
})
export class EstudianteModule { }
