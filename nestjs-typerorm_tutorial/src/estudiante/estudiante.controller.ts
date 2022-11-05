
import { Body, Controller, Delete, Get, Param, Post, Put, Query } from '@nestjs/common';
import { EstudianteDto } from './estudiante.interface';
import { EstudianteService } from './estudiante.service';
import { EstudiantesEntity } from './estudiantes.entity';

@Controller('estudiantes')
export class EstudianteController { 
    constructor(private readonly estudiantesServices: EstudianteService) { }

  
    @Get()
    async findAll(): Promise<EstudiantesEntity[]> {
      return await this.estudiantesServices.findAll();
    }

    @Post()
    async AddInfantePsicomotor(@Body() estudiante: EstudianteDto): Promise<EstudiantesEntity>{
        return await this.estudiantesServices.addEstudiantes(estudiante);
    }

    @Delete(':id')
    async delete(@Param() params) {
      return this.estudiantesServices.remove(params.id);
    }


}
