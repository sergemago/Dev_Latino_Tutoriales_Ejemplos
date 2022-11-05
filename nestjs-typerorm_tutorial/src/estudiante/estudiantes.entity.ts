import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';


@Entity('estudiantes')
export class EstudiantesEntity {

  @PrimaryGeneratedColumn()
  id: number;

  @Column({nullable: true})
  nombre: string;

  @Column({nullable: true})
  valor: string;

  @Column({ type: 'timestamp', default: () => "CURRENT_TIMESTAMP"})
  fecha: Date;

}